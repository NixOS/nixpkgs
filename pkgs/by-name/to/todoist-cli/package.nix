{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  todoist-cli,
}:
buildNpmPackage rec {
  pname = "todoist-cli";
  version = "5.4.8";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-cli";
    rev = "v${version}";
    sha256 = "sha256-0Xa3SeVChnvQ8plJbNGJD8BjH2Sk1C+ZoLPyv78D3c4=";
  };

  npmDepsHash = "sha256-UTCv5Hzri7or4X9nuzobA+wepQzIVBjeKl7mIeXXA1E=";

  doCheck = true;

  __structuredAttrs = true;

  passthru.tests.version = testers.testVersion {
    package = todoist-cli;
  };

  meta = {
    description = "A command-line interface for Todoist";
    homepage = "https://github.com/Doist/todoist-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ joaosreis ];
    mainProgram = "td";
  };
}
