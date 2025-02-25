{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "utpm";
  version = "0-unstable-2024-12-17";

  useFetchCargoVendor = true;
  cargoHash = "sha256-fqGxor2PgsQemnPNoZkgNUNc7yRg2eqHTLzJAVpt6+8=";

  src = fetchFromGitHub {
    owner = "Thumuss";
    repo = pname;
    rev = "6c2cabc8e7e696ea129f55aa7732a6be63bc2319";
    hash = "sha256-uuET0BG2kBFEEWSSZ35h6+tnqTTjEHOP50GR3IkL+CE=";
  };

  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  doCheck = false; # no tests

  meta = {
    description = "Package manager for typst";
    longDescription = ''
      UTPM is a package manager for local and remote packages. Create quickly
      new projects and templates from a singular tool, and then publish it directly
      to Typst!
    '';
    homepage = "https://github.com/Thumuss/utpm";
    license = lib.licenses.mit;
    mainProgram = "utpm";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
