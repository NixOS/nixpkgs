{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "texsurgery";
  version = "0.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zoOeTRHcpDnXJ1QC7BIz9guzqL9Q7kmJ5VSGEyqanfY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    jupyter-client
    pyparsing
  ];

  pythonImportsCheck = [
    "texsurgery"
    "texsurgery.texsurgery"
    "texsurgery.command_line"
  ];

  meta = {
    description = "Replace some commands and environments within a TeX document by evaluating code inside a jupyter kernel";
    homepage = "https://pypi.org/project/texsurgery";
    license = lib.licenses.mit;
    mainProgram = "texsurgery";
    maintainers = with lib.maintainers; [ romildo ];
  };
}
