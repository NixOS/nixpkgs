{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "ungit";
  version = "1.5.28";

  src = fetchFromGitHub {
    owner = "FredrikNoren";
    repo = "ungit";
    rev = "v${version}";
    hash = "sha256-zLc+qzbbaQs6Y3NJFHupxyZ0QfuM/VW97dFESR+5dVQ=";
  };

  npmDepsHash = "sha256-pYOBdCb6G24JBGWOhd4fyVEEUn19D9t/GxjjIi/2ya0=";

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
