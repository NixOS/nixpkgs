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
    # Using more recent commit to fix elm 0.19.2 support
    # tag = "v${finalAttrs.version}";
    rev = "63b84eca9642f6d0de37d6e35e0d8bc6edca19c6";
    hash = "sha256-tZ/XT/gZKu8iDmJPxYlLXCRCeOs7ZZiqWpYcyScfqVg=";
  };

  npmDepsHash = "sha256-Puz7AVXaUy/7wflTcqbrQhTwSeeiG3jkfXYJ7NXhXQ0=";

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
