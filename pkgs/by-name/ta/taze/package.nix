{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "taze";
  version = "19.9.2";
=======
let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taze";
  version = "19.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "antfu-collective";
    repo = "taze";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-6VH1j2v9gySalq6OXL1WzEApcaoE1VxHdrZtYv2xKZk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-SV8dHPydTOz/cbOY3p4npp0uMjh3hSXH9ZNk4BtHb4w=";
=======
    hash = "sha256-Xpi5Wc8YP3hUSbEnfEM6uNvdlNiVMRz0oqZAJCBkLHQ=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-g1LGiCb2NESywYN4tTVf8sXbuJla2whCm5amvPsdmRc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
