{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typstyle";
  version = "0.13.16";

  src = fetchFromGitHub {
    owner = "typstyle-rs";
    repo = "typstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dfw1jyPNZ0LDEZ+pbJt9DWKa4aBlFCAZIgKrZK+AmJw=";
  };

  cargoHash = "sha256-Eg8i+vsBp0BuxxBWXZisVKiGge25UKfxoK/3Knk+LsU=";

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
      drupol
      prince213
    ];
  };
})
