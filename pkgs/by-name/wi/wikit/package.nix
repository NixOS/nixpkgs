{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
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
  ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp ${finalAttrs.src}/data/wikit.1 $out/share/man/man1
  '';

  meta = {
    description = "Wikit gives Wikipedia summaries from the terminal";
    homepage = "https://github.com/KorySchneider/wikit";
    changelog = "https://github.com/KorySchneider/wikit/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "wikit";
  };
})
