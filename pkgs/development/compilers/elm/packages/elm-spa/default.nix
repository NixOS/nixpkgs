{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-spa";
  version = "6.0.6";

  src = fetchFromGitHub {
    owner = "ryan-haskell";
    repo = "elm-spa";
    tag = finalAttrs.version;
    hash = "sha256-s/Qf92QaeQ4Ld3dbT3PE5n+lEXvpKwiDFYO4Fal9FvE=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/cli";

  npmDepsHash = "sha256-7M6dZpKHMTr7G8Grf/RxNbcD+NXLalUlNkiedRM3Evc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ryan-haskell/elm-spa/releases/tag/${finalAttrs.version}";
    description = "Elm single-page-apps made easy";
    homepage = "https://www.elm-spa.dev/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-spa";
  };
})
