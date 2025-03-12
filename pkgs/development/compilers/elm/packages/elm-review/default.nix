{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  elm-review,
}:

buildNpmPackage rec {
  pname = "elm-review";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "jfmengels";
    repo = "node-elm-review";
    rev = "v${version}";
    hash = "sha256-HQ7ilGfw/sMXMQVoJQAj31LbyJfdCfbrZ22gTh1vbD8=";
  };

  npmDepsHash = "sha256-YuN04MAKSu4InfGIS0EIZiNpSbLHA7/WzJiMFWY0Tqk=";

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
