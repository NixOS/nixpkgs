{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "elm-test";
  version = "0.19.1-revision12";

  src = fetchFromGitHub {
    owner = "rtfeldman";
    repo = "node-test-runner";
    rev = version;
    hash = "sha256-cnxAOFcPTJjtHi4VYCO9oltb5iOeDnLvRgnuJnNzjsY=";
  };

  npmDepsHash = "sha256-QljHVrmF6uBem9sW67CYduCro3BqF34EPGn1BtKqom0=";

  postPatch = ''
    sed -i '/elm-tooling install/d' package.json
  '';

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/rtfeldman/node-test-runner/blob/${src.rev}/CHANGELOG.md";
    description = "Runs elm-test suites from Node.js";
    mainProgram = "elm-test";
    homepage = "https://github.com/rtfeldman/node-test-runner";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ turbomack ];
  };
}
