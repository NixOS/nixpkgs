{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-udVUX1qNaPDBI+nEjm7LQ+2+HG6TBlgsjyQOP8pBqao=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-iFqECXUMODxvjXQ4o0mD4dTdG9RYbpOBeyJzvteZZmI=";

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
