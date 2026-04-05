#! @nix@/bin/nix-shell
#! nix-shell -i @runtimeShell@ --pure @drv@ --keep UPDATE_NIX_ATTR_PATH
set -euo pipefail

tag=${1-}

if [[ -n $tag ]]; then
    query=$(cat <<EOF
        map(
            select(
                (.tag_name == "$tag"))) |
        first
EOF
    )
else
    query=$(cat <<EOF
        map(
            select(
                @prereleaseExpr@
                .draft == false and
                (.tag_name | startswith("v@sdkVersionPrefix@")))) |
        first
EOF
    )
fi

query="$query "$(cat <<EOF
    | (
        .tag_name,
        (.assets |
            .[] |
            select(.name == "release.json") |
            .browser_download_url),
        (.assets |
            .[] |
            select(.name | endswith(".tar.gz.sig")) |
            .browser_download_url))
EOF
)

(
    curl -fsSL https://api.github.com/repos/dotnet/dotnet/releases | \
    jq -er "$query" \
) | (
    read tagName
    read releaseUrl
    read sigUrl

    # TMPDIR might be really long, which breaks gpg
    tmp="$(TMPDIR=/tmp mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT

    cd "$tmp"

    curl -fsSL "$releaseUrl" -o release.json

    if [[ -z $tag && "$tagName" == "@tag@" ]]; then
        >&2 echo "release is already $tagName"
        exit
    fi

    tarballUrl=https://github.com/dotnet/dotnet/archive/refs/tags/$tagName.tar.gz

    mapfile -t prefetch < <(nix-prefetch-url --print-path "$tarballUrl")
    tarballHash=$(nix-hash --to-sri --type sha256 "${prefetch[0]}")
    tarball=${prefetch[1]}

    # recent dotnet 10 releases don't have a signature for the github tarball
    if [[ ! $sigUrl = */dotnet-source-* ]]; then
      curl -fssL "$sigUrl" -o release.sig

      (
          export GNUPGHOME=$PWD/.gnupg
          mkdir -m 700 -p $GNUPGHOME
          trap 'gpgconf --kill all' EXIT
          gpg --no-autostart --batch --import @releaseKey@
          gpg --no-autostart --batch --verify release.sig "$tarball"
      )
    fi

    tar --strip-components=1 --no-wildcards-match-slash --wildcards -xzf "$tarball" \*/eng/Versions.props \*/global.json \*/prep\*.sh
    artifactsVersion=$(xq -r '.Project.PropertyGroup |
        map(select(.PrivateSourceBuiltArtifactsVersion))
        | .[] | .PrivateSourceBuiltArtifactsVersion' eng/Versions.props)

    if [[ "$artifactsVersion" != "" ]]; then
        artifactVar=$(grep ^defaultArtifactsRid= prep-source-build.sh)
        eval "$artifactVar"

        artifactsFile=Private.SourceBuilt.Artifacts.$artifactsVersion.$defaultArtifactsRid.tar.gz
        artifactsUrl=@dotnetBuildUrl@/$artifactsFile

        curl -fsSL "$artifactsUrl" --head || {
          [[ $? == 22 ]]
          artifactsUrl=https://ci.dot.net/public/source-build/$artifactsFile
        }
    else
        artifactsUrl=$(xq -r '.Project.PropertyGroup |
            map(select(.PrivateSourceBuiltArtifactsUrl))
            | .[] | .PrivateSourceBuiltArtifactsUrl' eng/Versions.props)
        artifactsUrl="${artifactsUrl/dotnetcli.azureedge.net/builds.dotnet.microsoft.com}"
    fi

    artifactsHash=$(nix-prefetch-url "$artifactsUrl")
    artifactsHash=$(nix-hash --to-sri --type sha256 "$artifactsHash")

    sdkVersion=$(jq -er .tools.dotnet global.json)

    # below needs to be run in nixpkgs because toOutputPath uses relative paths
    cd -

    cp "$tmp"/release.json "@releaseManifestFile@"

    jq --null-input \
        --arg _0 "$tarballHash" \
        --arg _1 "$artifactsUrl" \
        --arg _2 "$artifactsHash" \
        '{
            "tarballHash": $_0,
            "artifactsUrl": $_1,
            "artifactsHash": $_2,
        }' > "@releaseInfoFile@"

    if [[ -n @bootstrapSdkFile@ ]]; then
        updateSDK() {
            @updateScript@ \
                -o @bootstrapSdkFile@ --sdk "$1" >&2
        }

        updateSDK "$sdkVersion" || if [[ $? == 2 ]]; then
            >&2 echo "WARNING: bootstrap sdk missing, attempting to bootstrap with self"
            updateSDK "$(jq -er .sdkVersion "$tmp"/release.json)"
        else
            exit 1
        fi
    fi

    $(nix-build -A $UPDATE_NIX_ATTR_PATH.fetch-deps --no-out-link) >&2
)
