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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = version;
    hash = "sha256-DuIT4jIxk+L7c+rWIzrNjNEs2Lv5mYqLeCAaBMsBCBg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ui4Bns5A25VrNer6wpD0agYJQwxuIYWSOO26u1K8Vmc=";

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
