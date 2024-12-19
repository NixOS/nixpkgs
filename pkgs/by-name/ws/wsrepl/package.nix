{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wsrepl";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doyensec";
    repo = "wsrepl";
    rev = "refs/tags/v${version}";
    hash = "sha256-Y96p39TjpErGsR5vFS0NxEF/2Tnr2Zk7ULDgNXaXx9o=";
  };

  pythonRelaxDeps = [
    "textual"
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    pygments
    pyperclip
    rich
    textual
    websocket-client
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "wsrepl"
  ];

  meta = with lib; {
    description = "WebSocket REPL";
    homepage = "https://github.com/doyensec/wsrepl";
    changelog = "https://github.com/doyensec/wsrepl/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "wsrepl";
  };
}
