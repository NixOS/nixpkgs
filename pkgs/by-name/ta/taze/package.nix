{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taze";
  version = "19.14.1";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "taze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tcyZ4nbMw+RjASQKOiMDUCYNSWBeJ0u/rQ9Dq81HA7Y=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-6J7yNwtekfMfsqeXWpNeqw4cak7z03494nYlBHRMZH0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
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
