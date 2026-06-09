{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9LEZ9DWp5H+ODiuE6A5Qzr/ozXQaXQ7TbDnJY8B8GD4=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-dGobKfemSrZ+Y4haHrmLt7dqv9yOBDJ2k3XnZ9LkIlw=";

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
