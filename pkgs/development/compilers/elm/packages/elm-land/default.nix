{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  elm-land,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "elm-land";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "elm-land";
    repo = "elm-land";
    rev = "v${version}";
    hash = "sha256-PFyiVTH2Cek377YZwaCmvDToQCaxWQvJrQkRhyNI2Wg=";
  };

  npmDepsHash = "sha256-Bg16s0tqEaUT+BbFMKuEtx32rmbZLIILp8Ra/dQGmUg";
  sourceRoot = "${src.name}/projects/cli";

  dontNpmBuild = true;

  passthru.tests = {
    version = testers.testVersion {
      version = "v${version}";
    package = elm-land;
    command = "elm-land --version";
    };
    integration_test = nixosTests.elm-land;
  };

  meta = {
    description = "A production-ready framework for building Elm applications.";
    mainProgram = "elm-land";
    homepage = "https://github.com/elm-land/elm-land";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      domenkozar
      zupo
    ];
  };
}
