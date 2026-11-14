# Run from the nixpkgs root.
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

# Upstream publishes these repositories separately. Only select a release
# available everywhere, including CLE's fixtures, before changing any files.
repos=(angr archinfo cle pyvex angr-management binaries)
for repo in "${repos[@]}"; do
    git ls-remote --tags --refs "https://github.com/angr/$repo.git" |
        sed -nE 's@.*refs/tags/v([0-9]+\.[0-9]+\.[0-9]+)$@\1@p' |
        LC_ALL=C sort -u > "$workdir/$repo"
    if [[ $repo == angr ]]; then
        cp "$workdir/$repo" "$workdir/common"
    else
        LC_ALL=C comm -12 "$workdir/common" "$workdir/$repo" > "$workdir/next"
        mv "$workdir/next" "$workdir/common"
    fi
done

version=$(sort -V "$workdir/common" | tail -n1)
if [[ -z $version ]]; then
    echo "No coordinated angr release found." >&2
    exit 1
fi

: > "$workdir/changes"
for package in python3Packages.{archinfo,pyvex,cle,angr} angr-management; do
    metadata=$(nix-instantiate --eval --strict --json --expr "
        let package = (import ./. {}).$package; in {
            oldVersion = package.version;
            files = [ (builtins.head (builtins.match \"(.*):[0-9]+\" package.meta.position)) ];
        }
    ")
    args=(--version="$version")
    if [[ $package == python3Packages.cle ]]; then
        args+=(--custom-dep=binaries)
    fi
    nix-update "$package" "${args[@]}" >&2
    jq --arg attrPath "$package" --arg newVersion "$version" \
        'select(.oldVersion != $newVersion) | . + {attrPath: $attrPath, newVersion: $newVersion}' \
        <<< "$metadata" >> "$workdir/changes"
done
jq -s . "$workdir/changes"
