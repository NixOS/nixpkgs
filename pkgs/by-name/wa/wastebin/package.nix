{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "wastebin";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = version;
    hash = "sha256-5L9ug/OOvobic3bYjz8KUkQdnaVmAb2ltXCCiZkVHOg=";
  };

  cargoHash = "sha256-KbYbsV3+xhGFgcKrdLMiQ5+1meePjXYMD9PltlO+QMA=";

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
