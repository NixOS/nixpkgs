{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttdl";
  version = "4.24.1";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tfyfFwHnIS5nCYobVu49AmjVKvxhngqD5woxyiv5FEc=";
  };

  cargoHash = "sha256-XH/F0ffWmIvesR0sA+AdnLV3IaLWrgin4YDJtkfbVDI=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${finalAttrs.version}/changelog";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
})
