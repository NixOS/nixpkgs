{
  lib,
  pkgs,
  stdenv,
  nodejs,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tact";
  version = "1.6.7";
  src = fetchFromGitHub {
    owner = "tact-lang";
    repo = "tact";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U1ZRob6lE/kAEVZ5XnXgeimrXPvdccUhxdCNIzP6Rj0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-7uQOXoFHAnZe+8KUgoHPMDkiOKUzQsj8ppHX3CR7RLI=";
  };

  yarnBuildScript = "build:fast";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  meta = {
    description = "Tact compiler for TON blockchain";
    changelog = "https://github.com/tact-lang/tact/releases/tag/v${finalAttrs.version}";
    homepage = "https://tact-lang.org/";
    maintainers = with lib.maintainers; [ ipsavitsky ];
    mainProgram = "tact"; # but also contains tact-fmt and unboc
    license = lib.licenses.mit;
  };
})
