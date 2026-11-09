{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttdl";
  version = "6.2.5";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-u8xEQ7U4E45cs/KPgYsBFIMS6b98iX6Zm02fYUSNoug=";
  };

  cargoHash = "sha256-57hgd/iB895EpEyiZSnuS/idY4lvsX9AYXqTfbfYC/M=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${finalAttrs.version}/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
})
