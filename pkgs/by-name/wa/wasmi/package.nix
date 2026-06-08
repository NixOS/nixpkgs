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
    owner = "wasmi-labs";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eFQ0dBOFE/vpRXfAYYZNncAVKMlaGf8jHvBT/a5UQRo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Vo5MGp3I/8sMDchNQORzlXS8z9Bp6cILnK4aYot9/FE=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient and versatile WebAssembly interpreter for embedded systems";
    homepage = "https://github.com/wasmi-labs/wasmi";
    changelog = "https://github.com/wasmi-labs/wasmi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "wasmi_cli";
  };
})
