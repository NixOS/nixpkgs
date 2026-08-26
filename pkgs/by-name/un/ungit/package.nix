{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "ungit";
  version = "1.5.30";

  src = fetchFromGitHub {
    owner = "FredrikNoren";
    repo = "ungit";
    rev = "v${version}";
    hash = "sha256-P1B+MuiqJ621My1teYMDUD7hID2BsHchb24DIsXB9gU=";
  };

  npmDepsHash = "sha256-cybFoGLZYmcVg1nQ4s8CqhVDpA4zR74B+qwM0fpuIsI=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  meta = {
    changelog = "https://github.com/FredrikNoren/ungit/blob/${src.rev}/CHANGELOG.md";
    description = "Git made easy";
    homepage = "https://github.com/FredrikNoren/ungit";
    license = lib.licenses.mit;
    mainProgram = "ungit";
    maintainers = [ ];
  };
}
