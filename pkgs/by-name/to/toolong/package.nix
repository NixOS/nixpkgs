{
  lib,
  python3Packages,
  fetchFromGitHub,
  testers,
  toolong,
}:

python3Packages.buildPythonApplication {
  pname = "toolong";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "toolong";
    rev = "5aa22ee878026f46d4d265905c4e1df4d37842ae"; # no tag
    hash = "sha256-HrmU7HxWKYrbV25Y5CHLw7/7tX8Y5mTsTL1aXGGTSIo=";
  };

  build-system = [ python3Packages.poetry-core ];
  dependencies = with python3Packages; [
    click
    textual
    typing-extensions
  ];

  pythonRelaxDeps = [ "textual" ];

  pythonImportsCheck = [ "toolong" ];
  doCheck = false; # no tests

  # From https://github.com/Textualize/toolong/pull/63, also fixes https://github.com/NixOS/nixpkgs/issues/360671
  patches = [ ./0001-log-view.patch ];

  passthru.tests.version = testers.testVersion {
    package = toolong;
    command = "${lib.getExe toolong} --version";
  };

  meta = with lib; {
    description = "Terminal application to view, tail, merge, and search log files (plus JSONL)";
    license = licenses.mit;
    homepage = "https://github.com/textualize/toolong";
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "tl";
  };
}
