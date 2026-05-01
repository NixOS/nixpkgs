{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
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

  npmDepsHash = "sha256-frNCo97GOwiClzQwRXHpqqjimJrmipsBebAshJqGZco=";

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
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-verify-examples";
  };
})
