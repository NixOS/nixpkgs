{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.11";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = "tickrs";
    tag = "v${version}";
    hash = "sha256-0jpElAj4TDC52BEjfnGHYiro6MT6Jzcb0evvmroxLn8=";
  };

  cargoHash = "sha256-Ii9Fn6J5qpqigH7oWIfOX+JKkzQ2BNpeNg1sF+ONCrM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tickrs";
  };
}
