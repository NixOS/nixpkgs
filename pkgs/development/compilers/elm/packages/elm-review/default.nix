{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  elm-review,
}:

buildNpmPackage rec {
  pname = "elm-review";
  version = "2.13.3";

  src = fetchFromGitHub {
    owner = "jfmengels";
    repo = "node-elm-review";
    rev = "v${version}";
    hash = "sha256-sK7kMKokoK4qUjSMaXMsD9FLkyUTEYcD6aU1+nFZq/s=";
  };

  npmDepsHash = "sha256-HthSqaoxpsqP3Zg0yrC5QxyeSVF9kkEokPZh7O3RzUY=";

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
