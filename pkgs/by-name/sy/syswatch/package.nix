{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jGVgp4K51saPkbQDV798asCGqc/zhO5vJjbOuXtFWpE=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-VfwNasoraA/OqsvhIWzAw/DLc+bwSU3Wgla3xuqh0AE=";

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
