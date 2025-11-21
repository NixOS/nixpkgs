{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-analyse";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "stil4m";
    repo = "elm-analyse";
    tag = finalAttrs.version;
    hash = "sha256-GFHhHf+JOXGcm0CZEDGMuuTR3CXBdSkYDGRHZ63pE64=";
  };

  npmDepsHash = "sha256-B/PzGOaxdKSt82ax0izeadsMsz+I0v4wkye3zgNxMF8=";

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    elmPackages.elm
  ];

  postConfigure =
    (elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    })
    + ''
      ln -sf ${lib.getExe elmPackages.elm} node_modules/.bin/elm
    '';

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  postInstall = ''
    rm -rf $out/lib/node_modules/elm-analyse/node_modules/.bin/
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Analyse your Elm code, identify deficiencies and apply best practices";
    homepage = "https://stil4m.github.io/elm-analyse/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-analyse";
  };
})
