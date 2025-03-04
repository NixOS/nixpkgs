{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "world-serpant-search";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Latrodect";
    repo = "wss-repo-vulnerability-search-manager";
    tag = "v${version}";
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

  meta = with lib; {
    description = "Command-line tool for vulnerability detection";
    homepage = "https://github.com/Latrodect/wss-repo-vulnerability-search-manager";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "serpant";
  };
}
