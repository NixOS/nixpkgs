{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.11";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-0jpElAj4TDC52BEjfnGHYiro6MT6Jzcb0evvmroxLn8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ii9Fn6J5qpqigH7oWIfOX+JKkzQ2BNpeNg1sF+ONCrM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "tickrs";
  };
}
