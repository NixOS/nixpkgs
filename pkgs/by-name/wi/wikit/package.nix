{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  installShellFiles,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wikit";
  version = "4.4-unstable-2022-10-17";

  src = fetchFromGitHub {
    owner = "KorySchneider";
    repo = "wikit";
    rev = "6432c6020606868cc5f240d0317040e38b992292";
    hash = "sha256-WCKLqxNtO+iECfBzQwMn31Pcz/cGWMihTvoHPaQAmak=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-UAqMpb7zM/oVxE6gNkjk6IUoufATc0q2TM10P/A1Rqs=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
    installShellFiles
  ];

  postInstall = ''
    installManPage ${finalAttrs.src}/data/wikit.1
  '';

  meta = {
    description = "Command line program for getting Wikipedia summaries";
    homepage = "https://github.com/KorySchneider/wikit";
    changelog = "https://github.com/KorySchneider/wikit/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "wikit";
  };
})
