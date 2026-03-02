{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yalc";
  version = "0-unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "wclr";
    repo = "yalc";
    # Upstream has no tagged versions
    rev = "3b834e488837e87df47414fd9917c10f07f0df08";
    hash = "sha256-v8OhLVuRhnyN2PrslgVVS0r56wGhYYmjoz3ZUZ95xBc=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-+w3azJEnRx4v3nJ3rhpLWt6CjOFhMMmr1UL5hg2ZR48=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Work with yarn/npm packages locally like a boss";
    mainProgram = "yalc";
    homepage = "https://github.com/wclr/yalc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
