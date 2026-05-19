#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix yq gnupg
set -euo pipefail

updateSdk() {
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
        sdkVersionPrefix=$channel.1

        query=$(cat <<EOF
            map(
                select(
                    .draft == false and
                    (.tag_name | startswith("v$sdkVersionPrefix")))) |
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

        release=${tagName#*.*.}
        band=${release:0:1}xx

        output="$(dirname "${BASH_SOURCE[0]}")"/../"$channel"

        if [[ $band != 1xx ]]; then
          output+=/$band
        fi

        mkdir -p "$output"

        [[ ! -e "$output"/release.json || $(jq -r .tag "$output"/release.json) != "$tagName" ]] || {
            >&2 echo "release is already $tagName"
            exit
        }

        # TMPDIR might be really long, which breaks gpg
        tmp="$(TMPDIR=/tmp mktemp -d)"
        trap 'rm -rf "$tmp"' EXIT

        cd "$tmp"

        curl -fsSL "$releaseUrl" -o release.json

        tarballUrl=https://github.com/dotnet/dotnet/archive/refs/tags/$tagName.tar.gz

        mapfile -t prefetch < <(nix-prefetch-url --print-path "$tarballUrl")
        tarballHash=$(nix-hash --to-sri --type sha256 "${prefetch[0]}")
        tarball=${prefetch[1]}

        # recent dotnet 10 releases don't have a signature for the github tarball
        if [[ ! $sigUrl = */dotnet-source-* ]]; then
          curl -fssL "$sigUrl" -o release.sig
          curl -fssLO https://dotnet.microsoft.com/download/dotnet/release-key-2023.asc
          echo '17aebc401e7999dd0642fa06d23780eba15bd916ebb118454f34db5c85f7194a  release-key-2023.asc' |
            sha256sum -c

          (
              export GNUPGHOME=$PWD/.gnupg
              mkdir -m 700 -p $GNUPGHOME
              trap 'gpgconf --kill all' EXIT
              gpg --no-autostart --batch --import release-key-2023.asc
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

            dotnetBuildUrl=https://builds.dotnet.microsoft.com/

            if [[ $major -ge 10 ]]; then
                dotnetBuildUrl+=dotnet/source-build
            else
                dotnetBuildUrl+=source-built-artifacts/assets
            fi

            artifactsUrl=$dotnetBuildUrl/$artifactsFile

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

        cp "$tmp"/release.json "$output"

        jq --null-input \
            --arg _0 "$tarballHash" \
            --arg _1 "$artifactsUrl" \
            --arg _2 "$artifactsHash" \
            '{
                "tarballHash": $_0,
                "artifactsUrl": $_1,
                "artifactsHash": $_2,
            }' > "$output"/release-info.json

        if [[ $band == 1xx ]]; then
            getBootstrap() {
                pkgs/development/compilers/dotnet/binary/update.sh \
                    -o "$output"/bootstrap-sdk.nix --sdk "$1" >&2
            }

            getBootstrap "$sdkVersion" || if [[ $? == 2 ]]; then
                >&2 echo "WARNING: bootstrap sdk missing, attempting to bootstrap with self"
                getBootstrap "$(jq -er .sdkVersion "$tmp"/release.json)"
            else
                exit 1
            fi

            $(nix-build -A dotnetCorePackages.dotnet_$major.vmr.fetch-deps --no-out-link) >&2
        fi
    )
}

while [ $# -gt 0 ]; do
    channel="$1"
    shift

    major="${channel%.*}"

    if [[ $major -lt 8 ]]; then
        >&2 echo "dotnet $major has no vmr"
        continue
    fi

    curl -fsSL https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/"$channel"/releases.json |
        jq -r '.releases[0].sdks.[] | .version' | {
        while read sdk; do
            if [[ $major -lt 10 && $sdk != *.*.1* ]]; then
                >&2 echo "sdk $sdk has no vmr"
                continue
            fi

            updateSdk v"$sdk"
        done
    }
done
