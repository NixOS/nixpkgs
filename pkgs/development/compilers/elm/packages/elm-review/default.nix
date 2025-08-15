{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  elm-review,
}:

buildNpmPackage rec {
  pname = "elm-review";
  version = "2.13.4";

  src = fetchFromGitHub {
    owner = "jfmengels";
    repo = "node-elm-review";
    rev = "v${version}";
    hash = "sha256-rhNLIShZERxrzdTdrPcthTQ+gHUikgR0jchBfcBDGTo=";
  };

  npmDepsHash = "sha256-mI94fYNKZ9Jx1Iyo/VjZqaXQ64tZA2S8mtn5l6TtCSc=";

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
