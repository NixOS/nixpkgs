{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
  fetchpatch,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-verify-examples";
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "stoeffel";
    repo = "elm-verify-examples";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUmIrwmJyGvkCRHRiA069Aj25WBIGtJ7DJxwwF6OvWU=";
  };

  npmDepsHash = "sha256-QbYHG7A41ra/DM9U5USKDflohAL09VPTtPZl1tcx16Y=";

  patches = [
    # upstream PR: https://github.com/stoeffel/elm-verify-examples/pull/118/
    (fetchpatch {
      url = "https://github.com/turboMaCk/elm-verify-examples/commit/35791dc02d7ab1a9622bda6860783cc58c4340b5.patch";
      hash = "sha256-3+JNY1sASuLF0XrzqGrOGto4Nqs1QCZEOJABJPJ3Bmg=";
    })
  ];

  nativeBuildInputs = [
    elmPackages.elm
  ];

  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  postConfigure = (
    elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    }
  );

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Verify examples in your docs";
    homepage = "https://github.com/stoeffel/elm-verify-examples";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "elm-verify-examples";
  };
})
