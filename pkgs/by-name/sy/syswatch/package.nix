{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fKMNnx5aBr2oSk2VJWz2TKHF7fJ1Lv2lRxnd89Vy4hA=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-4wTyf+VsoQpPNCydr57Q3/zi2/Bvqt7tvkqYwjTZKMg=";

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-V" ];

  meta = {
    description = "Single-host system diagnostics TUI tool";
    homepage = "https://github.com/matthart1983/syswatch";
    changelog = "https://github.com/matthart1983/syswatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "syswatch";
  };
})
