{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyqtgraph,
  numpy,
  pyqt5,
  pyqt6,
  pyside6,
}:

buildPythonPackage rec {
  pname = "pglive";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domarm-comat";
    repo = "pglive";
    tag = "v${version}";
    hash = "sha256-JZ/XfNtGGrlNY/NN+OrN9RlI3ZK/TFNP7SZxNaEm38A=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyqtgraph
    numpy
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  passthru.optional-dependencies = {
    pyqt5 = [ pyqt5 ];
    pyqt6 = [ pyqt6 ];
    pyside6 = [ pyside6 ];
  };

  pythonImportsCheck = [ "pglive" ];

  meta = {
    changelog = "https://github.com/domarm-comat/pglive/releases/tag/${src.tag}";
    description = "Live plot for PyqtGraph";
    homepage = "https://github.com/domarm-comat/pglive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
