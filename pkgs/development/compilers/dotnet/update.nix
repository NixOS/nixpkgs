{ stdenvNoCC
, lib
, fetchurl
, writeScript
, nix
, runtimeShell
, curl
, cacert
, jq
, yq
, gnupg

, releaseManifestFile
, releaseInfoFile
, allowPrerelease
}:

let
  inherit (lib.importJSON releaseManifestFile) channel release;

  pkg = stdenvNoCC.mkDerivation {
    name = "update-dotnet-vmr-env";

    nativeBuildInputs = [
      nix
      curl
      cacert
      jq
      yq
      gnupg
    ];
  };

  releaseKey = fetchurl {
    url = "https://dotnet.microsoft.com/download/dotnet/release-key-2023.asc";
    hash = "sha256-F668QB55md0GQvoG0jeA66Fb2RbrsRhFTzTbXIX3GUo=";
  };

  drv = builtins.unsafeDiscardOutputDependency pkg.drvPath;

in writeScript "update-dotnet-vmr.sh" ''
  #! ${nix}/bin/nix-shell
  #! nix-shell -i ${runtimeShell} --pure ${drv}
  set -euo pipefail

  query=$(cat <<EOF
      map(
          select(
              ${lib.optionalString (!allowPrerelease) ".prerelease == false and"}
              .draft == false and
              (.name | startswith(".NET ${channel}")))) |
      first | (
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
      curl -fsL https://api.github.com/repos/dotnet/dotnet/releases | \
      jq -r "$query" \
  ) | (
      read tagName
      read releaseUrl
      read sigUrl

      tmp="$(mktemp -d)"
      trap 'rm -rf "$tmp"' EXIT

      cd "$tmp"

      curl -fsL "$releaseUrl" -o release.json
      release=$(jq -r .release release.json)

      if [[ "$release" == "${release}" ]]; then
          >&2 echo "release is already $release"
          exit
      fi

      tarballUrl=https://github.com/dotnet/dotnet/archive/refs/tags/$tagName.tar.gz

      mapfile -t prefetch < <(nix-prefetch-url --print-path "$tarballUrl")
      tarballHash=$(nix-hash --to-sri --type sha256 "''${prefetch[0]}")
      tarball=''${prefetch[1]}

      curl -L "$sigUrl" -o release.sig

      export GNUPGHOME=$PWD/.gnupg
      gpg --batch --import ${releaseKey}
      gpg --batch --verify release.sig "$tarball"

      tar --strip-components=1 --no-wildcards-match-slash --wildcards -xzf "$tarball" \*/eng/Versions.props
      artifactsVersion=$(xq -r '.Project.PropertyGroup |
          map(select(.PrivateSourceBuiltArtifactsVersion))
          | .[] | .PrivateSourceBuiltArtifactsVersion' eng/Versions.props)

      if [[ "$artifactsVersion" != "" ]]; then
          artifactsUrl=https://dotnetcli.azureedge.net/source-built-artifacts/assets/Private.SourceBuilt.Artifacts.$artifactsVersion.centos.8-x64.tar.gz
      else
          artifactsUrl=$(xq -r '.Project.PropertyGroup |
              map(select(.PrivateSourceBuiltArtifactsUrl))
              | .[] | .PrivateSourceBuiltArtifactsUrl' eng/Versions.props)
      fi

      artifactsHash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$artifactsUrl")")

      jq --null-input \
          --arg _0 "$tarballHash" \
          --arg _1 "$artifactsUrl" \
          --arg _2 "$artifactsHash" \
          '{
              "tarballHash": $_0,
              "artifactsUrl": $_1,
              "artifactsHash": $_2,
          }' > "${toString releaseInfoFile}"

      cp release.json "${toString releaseManifestFile}"
  )
''
