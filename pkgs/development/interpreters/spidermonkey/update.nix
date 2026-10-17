{
  writeShellApplication,
  common-updater-scripts,
  coreutils,
  curl,
  gnugrep,
  gnupg,
  gnused,
  xidel,
  baseUrl ? "https://archive.mozilla.org/pub/firefox/releases/",
  version ? "",
}:
writeShellApplication {
  name = "update-spidermonkey_${version}";
  runtimeInputs = [
    common-updater-scripts
    coreutils
    curl
    gnugrep
    gnupg
    gnused
    xidel
  ];

  text = ''
    set -eux

    HOME=$(mktemp -d)
    GNUPGHOME=$(mktemp -d)
    export GNUPGHOME

    curl https://keys.openpgp.org/vks/v1/by-fingerprint/09BEED63F3462A2DFFAB3B875ECB6497C1A20256 | gpg --import -

    version=$(xidel --trace -s "${baseUrl}" --extract "//a" | \
     grep "^${version}[0-9.]*esr/$" | \
     sed s/[/]$// | \
     sort --version-sort | \
     tail -n 1)

    curl --silent --show-error -o "$HOME"/shasums "${baseUrl}$version/SHA512SUMS"
    curl --silent --show-error -o "$HOME"/shasums.asc "${baseUrl}$version/SHA512SUMS.asc"
    gpgv --keyring="$GNUPGHOME"/pubring.kbx "$HOME"/shasums.asc "$HOME"/shasums

    hash=$(grep '\.source\.tar\.xz$' "$HOME"/shasums | grep '^[^ ]*' -o)
    sri_hash=$(nix hash convert --hash-algo sha512 --to sri "$hash")
    update-source-version --file=pkgs/development/interpreters/spidermonkey/${version}.nix \
      "spidermonkey_${version}" "''${version%esr}" "$sri_hash"
  '';
}
