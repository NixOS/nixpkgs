{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viddy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RyPG8OAg3i9N2Fq5Hij48wMvfQuTNmJFpatvB3HbXKg=";
  };

  cargoHash = "sha256-P+TtxV2kuHeBHr8GQeJ0VWPkjimfcAtBUFt0z79ML6A=";

  __structuredAttrs = true;

  env = {
    VERGEN_BUILD_DATE = "2026-06-14"; # managed via the update script
    VERGEN_GIT_DESCRIBE = "Nixpkgs";
  };

  doInstallCheck = true;
  versionCheckProgramArg = "-V";
  versionCheckKeepEnvironment = [ "VIDDY_DATA" ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  preInstallCheck = ''
    export VIDDY_DATA="$PWD";
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/sachaos/viddy/releases/tag/${finalAttrs.src.rev}";
    description = "Modern `watch` command";
    homepage = "https://github.com/sachaos/viddy";
    license = lib.licenses.mit;
    mainProgram = "viddy";
    maintainers = with lib.maintainers; [
      j-hui
      phanirithvij
    ];
  };
})
