{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "txm";
  version = "0.1.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thatmagicalcat";
    repo = "txm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3UkxQDm0OJuCLx2pIsjynDrjIgBHRpwwEkjSQDmhOzY=";
  };

  cargoHash = "sha256-tibIgVKntQQFOGdDT3DQkoWNTHlIPmDShZv10lKL/+w=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal math rendering engine with LaTeX support";
    homepage = "https://github.com/thatmagicalcat/txm";
    changelog = "https://github.com/thatmagicalcat/txm/releases/tag/v${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ DuskyElf ];
    mainProgram = "txm";
    platforms = lib.platforms.all;
  };
})
