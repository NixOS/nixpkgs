{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zeekscript";
  version = "1.3.2-unstable-2025-09-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "zeekscript";
    rev = "f0fa5746633a709759a94695fcc81b43feb8e2d9";
    hash = "sha256-g4Iv9xw6Owuqi+UudRzWatK09mjNDWdp0cBvH7iuV+U=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    argcomplete
    tree-sitter
    tree-sitter-zeek
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkInputs = with python3.pkgs; [ syrupy ];

  pythonImportsCheck = [
    "zeekscript"
  ];

  meta = {
    description = "Zeek script formatter and analyzer";
    homepage = "https://github.com/zeek/zeekscript";
    changelog = "https://github.com/zeek/zeekscript/blob/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      tobim
      mdaniels5757
    ];
  };
}
