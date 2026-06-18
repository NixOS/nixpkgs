{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2+ZF9QiJx37Jc7NqjkrrH/1llHfYtckrpiu0WiT4GAE=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-2iGSUhar6babzJUF3JVBdKleeyLSEuZoOEndCbOIfxY=";

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
