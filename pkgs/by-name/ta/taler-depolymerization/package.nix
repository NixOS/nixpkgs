{
  lib,
  rustPlatform,
  fetchgit,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage {
  pname = "taler-depolymerization";
  version = "0-unstable-2024-06-17";

  src = fetchgit {
    url = "https://git.taler.net/depolymerization.git/";
    rev = "a0d27ac3bba22d4934ca9f7b244b0d9e45bb484f";
    hash = "sha256-HmQ/DPq/O6aODWms/bSsCVgBF7z246xxfYxiHrAkgYw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-P0VrXYbO4RD3cNTai2hfTksbiGldkwoYgZm+C5Jh/4Y=";

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    # fix missing expression in test docs
    substituteInPlace common/src/status.rs \
      --replace-fail '          -> Requested' '()        -> Requested'
  '';

  postInstall = ''
    mkdir -p $doc/share/doc $out/share/examples

    cp -R docs $doc/share/doc/taler-depolymerization
    cp docs/*.conf $out/share/examples
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreFoundation
      Security
      SystemConfiguration
    ]
  );

  meta = {
    description = "Wire gateway for Bitcoin/Ethereum";
    homepage = "https://git.taler.net/depolymerization.git/";
    license = lib.licenses.agpl3Only;
    maintainers = lib.teams.ngi.members;
  };
}
