{
  lib,
  fetchFromGitea,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uwu-colors";
  version = "0.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "q60";
    repo = "uwu_colors";
    tag = finalAttrs.version;
    hash = "sha256-qzqfLTww0m1rv/7oJZrHMk63CtOk4RzY+Owx0oqlVzI=";
  };

  cargoHash = "sha256-R/IZUFr8Cir34c+C7Kq6FTFEERiInGMF8yFcC0uQ7Us=";

  meta = {
    description = "Simple LSP server made to display colors via textDocument/documentColor";
    mainProgram = "uwu_colors";
    homepage = "https://codeberg.org/q60/uwu_colors";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ vel ];
  };
})
