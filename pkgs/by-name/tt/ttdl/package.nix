{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttdl";
  version = "6.2.3";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OA8hmDPTCqUMdAaaQswCv70ZBHd6USe4Cpol4LavBzY=";
  };

  cargoHash = "sha256-eWDYx9hEt77zmEWOkmjs9DRvHOV3y+cwNOvrGa5eo60=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${finalAttrs.version}/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
})
