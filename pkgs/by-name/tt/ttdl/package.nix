{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-nA5fX8NZko49ctgwJOt0A07/7SFyM5I2840zeBZnFCs=";
  };

  cargoHash = "sha256-yCEdsxoKxudI7ae8Lz+8TAFblJSSB4tSD3GLdT6VtFI=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
