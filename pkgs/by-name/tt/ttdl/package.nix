{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-A3hzGBimQ2p4AjCKCHQaEe2U6GUaoTZdDEzmUcJuTfA=";
  };

  cargoHash = "sha256-NpV7SxRrLREtpyB59mdLk3KoGOIMvsxs71eQqKgo6EY=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
