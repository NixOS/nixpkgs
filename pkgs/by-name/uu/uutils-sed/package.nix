{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-sed";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "sed";
    tag = finalAttrs.version;
    hash = "sha256-KBeZcVFFoiMblonSvtfA9I9udYj9VP5NtjbcLvhQchM=";
  };

  cargoHash = "sha256-5Zo9IvIAjwzW7QY4YDxUN8+Fudz9xhQiwPMuXZ8wx/A=";

  meta = {
    changelog = "https://github.com/uutils/sed/releases/tag/${finalAttrs.version}";
    description = "Rewrite of sed in Rust";
    homepage = "https://github.com/uutils/sed";
    license = lib.licenses.mit;
    mainProgram = "sed";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
