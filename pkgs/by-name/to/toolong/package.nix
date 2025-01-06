{
  lib,
  python311Packages,
  fetchFromGitHub,
  testers,
  toolong,
}:

python311Packages.buildPythonApplication rec {
  pname = "toolong";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "toolong";
    tag = "v${version}";
    hash = "sha256-Zd6j1BIrsLJqptg7BXb67qY3DaeHRHieWJoYYCDHaoc=";
  };

  build-system = [ python311Packages.poetry-core ];
  dependencies = with python311Packages; [
    click
    textual
    typing-extensions
  ];

  pythonRelaxDeps = [ "textual" ];

  pythonImportsCheck = [ "toolong" ];
  doCheck = false; # no tests

  passthru.tests.version = testers.testVersion {
    package = toolong;
    command = "${lib.getExe toolong} --version";
  };

  meta = {
    description = "Terminal application to view, tail, merge, and search log files (plus JSONL)";
    license = lib.licenses.mit;
    homepage = "https://github.com/textualize/toolong";
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "tl";
  };
}
