{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tomlq";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cryptaliagy";
    repo = "tomlq";
    tag = version;
    hash = "sha256-4lqp1vlgHiGjCxmQ7FMgsoG/e1VDwTZBXp8QRGkotgw=";
  };

  cargoHash = "sha256-lO5q+IPC/68qq2y6+igDsx98TFA/sL0XLZAgJN4kqi8=";

  meta = {
    description = "Tool for getting data from TOML files on the command line";
    homepage = "https://github.com/cryptaliagy/tomlq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinzoku ];
    mainProgram = "tq";
  };
}
