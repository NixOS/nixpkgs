{
  lib,
  writeShellScript,
  coreutils,
  gnused,
  gnugrep,
  curl,
  gnupg,
  nix,
  common-updater-scripts,

  # options
  pname,
  version,
  meta,
  baseUrl ? "https://dist.torproject.org/torbrowser/",
  # name used to match published archive
  name ? "tor-browser",
  prerelease ? false,
}:

let
  versionMatch = if prerelease then ''[0-9]+(\.[0-9]+)*.*'' else ''[0-9]+(\.[0-9]+)*'';
in
writeShellScript "update-${pname}" ''
  PATH="${
    lib.makeBinPath [
      coreutils
      curl
      gnugrep
      gnused
      gnupg
      nix
      common-updater-scripts
    ]
  }"
  set -euo pipefail

  trap

  url=${baseUrl}
  version=$(curl -s $url \
            | sed -rne 's,^.*href="(${versionMatch})/".*,\1,p' \
            | sort --version-sort | tail -1)

  if [[ "${version}" = "$version" ]]; then
      echo "The new version same as the old version."
      exit 0
  fi

  HOME=$(mktemp -d)
  export GNUPGHOME=$(mktemp -d)
  trap 'rm -rf "$HOME" "$GNUPGHOME"' EXIT

  gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
  gpg --output $HOME/tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290

  curl --silent --show-error --fail -o $HOME/shasums "$url$version/sha256sums-signed-build.txt"
  curl --silent --show-error --fail -o $HOME/shasums.asc "$url$version/sha256sums-signed-build.txt.asc"
  gpgv --keyring=$HOME/tor.keyring $HOME/shasums.asc $HOME/shasums

  declare -A platforms=(
    ['x86_64-linux']='linux-x86_64'
    ['i686-linux']='linux-i686'
  )

  for platform in ${lib.escapeShellArgs meta.platforms}; do
    arch="''${platforms[$platform]}"
    sha256=$(grep "${name}-$arch-$version.tar.xz" "$HOME/shasums" | cut -d" " -f1)
    hash=$(nix hash to-sri --type sha256 "$sha256")

    update-source-version "${pname}" "$version" "$hash" --ignore-same-version --source-key="sources.$platform"
  done
''
