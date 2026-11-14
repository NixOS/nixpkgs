{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xre";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "xre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-auK7A99QdIJehj0tsM2WH/QEcNktZddoG86zwXD4g4Q=";
  };

  cargoHash = "sha256-ZgPMMUc5nGJMDY3q3n+37Nv0kjRIARooHG2RxWI3o88=";

  meta = {
    description = "Fast regex extraction tool with pattern matching, replacement, and configurable sorting";
    homepage = "https://github.com/wfxr/xre";
    changelog = "https://github.com/wfxr/xre/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "xre";
  };
})
