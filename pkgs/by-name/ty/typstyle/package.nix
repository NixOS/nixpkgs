{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typstyle";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vk/u5Q1MN6JlZuY4PnDEw52SSVYCciJUAbBduf2JiZQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XYBkfyomZiTjZccux72dc4Ku4Zec4ms6m5U2xwFgjEY=";

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
    changelog = "https://github.com/Enter-tainer/typstyle/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Format your typst source code";
    homepage = "https://github.com/Enter-tainer/typstyle";
    license = lib.licenses.asl20;
    mainProgram = "typstyle";
    maintainers = with lib.maintainers; [
      drupol
      prince213
    ];
  };
})
