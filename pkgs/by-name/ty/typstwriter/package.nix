{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "typstwriter";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bzero";
    repo = "typstwriter";
    rev = "V${version}";
    hash = "sha256-LhK1e6q7nmk13ZW55/1uEKhg7stQLIs+2bdFJDc24bg=";
  };

  build-system = [ python3.pkgs.flit-core ];

  dependencies = with python3.pkgs; [
    pygments
    pyside6
    qtpy
    send2trash
    superqt
  ];

  optional-dependencies = with python3.pkgs; {
    tests = [
      pytest
      pytest-qt
    ];
  };

  pythonImportsCheck = [ "typstwriter" ];

  meta = {
    changelog = "https://github.com/Bzero/typstwriter/releases/tag/V${version}";
    description = "Integrated editor for the typst typesetting system";
    homepage = "https://github.com/Bzero/typstwriter";
    license = lib.licenses.mit;
    mainProgram = "typstwriter";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
