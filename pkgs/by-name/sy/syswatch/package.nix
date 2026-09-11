{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BLl2A14CYTMXD5cjFwjhuiAo/WPIiyqfc2uGCRXXTKg=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-zZENTqVwL8au2C5LoXzpGF1EY9kTCHKV9pFV5+O5zJg=";

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Single-host system diagnostics TUI tool";
    homepage = "https://www.netwatchlabs.com/labs/syswatch";
    changelog = "https://github.com/matthart1983/syswatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      tomasrivera
    ];
    mainProgram = "syswatch";
  };
})
