{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttdl";
  version = "4.25.1";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gDR9EQN1EorqELaWUk+0sFwa6FxjmdkCLXudnFRjs+U=";
  };

  cargoHash = "sha256-+G2F5HGv57JqKJF6G1I7gLOrQSma9RUXdG4CVsdplaE=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${finalAttrs.version}/changelog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
})
