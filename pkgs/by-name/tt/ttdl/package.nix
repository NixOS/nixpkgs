{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttdl";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tHK8R+FFgQRbwBBWaeNAxCXtzEhrTVIq6vl8j3YvnDk=";
  };

  cargoHash = "sha256-/IE64OeMwmOHGnGJXvDdAUzIVggzNk54Nh4qIuYwOj4=";

  meta = {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${finalAttrs.version}/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
})
