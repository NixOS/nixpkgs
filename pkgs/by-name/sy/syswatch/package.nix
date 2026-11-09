{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YIXcKVnJ8uv74t0oPC73vdzcFY3YlFNy7XywJLl5FeU=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-yhTPEVb3ezGAKrVbwTSyukGUayqgF0xu2dfD+mAXlo4=";

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
