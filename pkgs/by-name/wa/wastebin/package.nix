{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "wastebin";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = version;
    hash = "sha256-7+Ufin68gMQtKv8SC8Gmn0Ra2qpumsKYgpURTkVqzt8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-j9Wpo3N1kwCvjDEqmn87rGSYFVw1ZGkSps72zVpXNls=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
    zstd
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
