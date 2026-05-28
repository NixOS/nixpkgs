{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "multitask";
  version = "0.44.3";

  src = fetchFromGitHub {
    owner = "leakec";
    repo = "multitask";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dtAGjF7EwtVL+IUF55ePsRhYfjfe+sXB+vpMhQFWPfA=";
  };

  cargoHash = "sha256-L3Vx+3YUDOpL65wlHRNAuhBsGfDfnhEPbTlKTQEXXtw=";

  meta = {
    description = "Mini-CI as a Zellij plugin";
    homepage = "https://github.com/leakec/multitask";
    changelog = "https://github.com/leakec/multitask/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
