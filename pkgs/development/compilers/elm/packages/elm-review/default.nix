{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  elm-review,
}:

buildNpmPackage rec {
  pname = "elm-review";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "jfmengels";
    repo = "node-elm-review";
    rev = "v${version}";
    hash = "sha256-f7VEYTvFbNbHnl/aGeQdDxCr/PtkaLBJw9FVpk2T9is=";
  };

  npmDepsHash = "sha256-5tSe/nK3X1MgX7uwTrFApw60i8c14ZWbk+IrgXMxTVc";

  postPatch = ''
    sed -i "s/elm-tooling install/echo 'skipping elm-tooling install'/g" package.json
  '';

  dontNpmBuild = true;

  passthru.tests.version = testers.testVersion {
    version = "${version}";
    package = elm-review;
    command = "elm-review --version";
  };

  meta = {
    changelog = "https://github.com/jfmengels/node-elm-review/blob/v${src.rev}/CHANGELOG.md";
    description = "Analyzes Elm projects, to help find mistakes before your users find them";
    mainProgram = "elm-review";
    homepage = "https://github.com/jfmengels/node-elm-review";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      turbomack
      zupo
    ];
  };
}
