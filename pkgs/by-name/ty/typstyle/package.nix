{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typstyle";
  version = "0.13.19";

  src = fetchFromGitHub {
    owner = "typstyle-rs";
    repo = "typstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8gM20/dGe6VH36C2y0rcMV1aKT7aAxHhy4TigTKbCxM=";
  };

  cargoHash = "sha256-CIU616FI26WtRceI/vZbaJgOm7532i0uzCzfhMz6plc=";

  # Disabling tests requiring network access
  checkFlags = [
    "--skip=e2e"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/typstyle-rs/typstyle/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/typstyle-rs/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [
      prince213
    ];
  };
})
