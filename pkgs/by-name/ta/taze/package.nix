{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taze";
  version = "19.9.2";

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "taze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6VH1j2v9gySalq6OXL1WzEApcaoE1VxHdrZtYv2xKZk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-SV8dHPydTOz/cbOY3p4npp0uMjh3hSXH9ZNk4BtHb4w=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
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
