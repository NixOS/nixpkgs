{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taze";
  version = "19.0.2";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "taze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ABmjfB0ovdi+x9Lya4RIZFlesMrY48g/ONmS+dzIn/I=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-lWWf0ipzjjgx0LWx8YKvYBLZW0vEW6RnpZE+xi/bGFc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build
    find dist -type f \( -name '*.cjs' -or -name '*.cts' -or -name '*.ts' \) -delete

    runHook postBuild
  '';

  dontNpmPrune = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern cli tool that keeps your deps fresh";
    homepage = "https://github.com/antfu-collective/taze";
    changelog = "https://github.com/antfu-collective/taze/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "taze";
  };
})
