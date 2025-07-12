{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "wsrepl";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doyensec";
    repo = "wsrepl";
    tag = "v${version}";
    hash = "sha256-Y96p39TjpErGsR5vFS0NxEF/2Tnr2Zk7ULDgNXaXx9o=";
  };

  pythonRelaxDeps = [
    "rich"
    "textual"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "WebSocket REPL";
    homepage = "https://github.com/doyensec/wsrepl";
    changelog = "https://github.com/doyensec/wsrepl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wsrepl";
  };
}
