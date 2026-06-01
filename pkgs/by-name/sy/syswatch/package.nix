{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-93KSbhgobGqd29M+cwEr6b1NhrwKhM+nJbRWG/hnvag=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-BRmkznPCS8BTLxeHAVz4eBsJZoKdDsaPE2VWMiquMac=";

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
