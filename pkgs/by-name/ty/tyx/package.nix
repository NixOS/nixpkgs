{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tyx";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "tyx-editor";
    repo = "TyX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kc1HX669D0FsrUkrS5yPV7cE5fuAMeBiZ6yxcv7GojQ=";
  };

  fetchCargoVendor = true;
  cargoHash = "sha256-gBo6aSb3nqfSBavsCq6ZcJZ8j7h4pnb8tZ0ShoagHDQ=";

  meta = {
    description = "A LyX-like experience rewritten for Typst and the modern era";
    homepage = "https://github.com/tyx-editor/TyX";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tyx";
  };
})
