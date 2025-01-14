{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  stdenv,
  darwin,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "wastebin";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = version;
    hash = "sha256-iiGg5En7p+7142qURsdOj7nYwS/ushbxfa5QlT/pHDc=";
  };

  cargoHash = "sha256-yfjAtORymdSn0pLwnGPvjLH3/R4juY08+NanTdm4420=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      sqlite
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.tests = {
    inherit (nixosTests) wastebin;
  };

  meta = with lib; {
    description = "Wastebin is a pastebin";
    homepage = "https://github.com/matze/wastebin";
    changelog = "https://github.com/matze/wastebin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      pinpox
      matthiasbeyer
    ];
    mainProgram = "wastebin";
  };
}
