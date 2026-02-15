{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmi";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eFQ0dBOFE/vpRXfAYYZNncAVKMlaGf8jHvBT/a5UQRo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Vo5MGp3I/8sMDchNQORzlXS8z9Bp6cILnK4aYot9/FE=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "wasmi_cli";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
