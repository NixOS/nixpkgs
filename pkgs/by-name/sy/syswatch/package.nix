{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6wdchl+m8rpMZSvEUu0CFymszo8oA+C5VeHfAMDB/vw=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-CtV74uU30SBZsBgrnN0P5V1zqR/HsbikuEZICuhiwDY=";

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
