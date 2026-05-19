{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "world-serpant-search";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Latrodect";
    repo = "wss-repo-vulnerability-search-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jXTivaXHHt63u9N7w40jyLUU2kg5LxAn50PVpqwUc0M=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    alive-progress
    colorlog
    requests
    termcolor
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Command-line tool for vulnerability detection";
    homepage = "https://github.com/Latrodect/wss-repo-vulnerability-search-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "serpant";
  };
})
