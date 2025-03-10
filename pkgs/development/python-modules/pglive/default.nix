{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pyqtgraph,
  numpy,
  pyqt5,
  pyqt6,
  pyside6,
  mypy,
}:

buildPythonPackage rec {
  pname = "pglive";
  version = "0.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y/9ng9d2cFxZAZBcWcGUE2nBqRp5GSsaoC7UoLETfsA=";
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

  nativeCheckInputs = [
    mypy
  ];

  # No available tests
  doCheck = false;

  pythonImportsCheck = [ "pglive" ];

  meta = {
    changelog = "https://github.com/domarm-comat/pglive/releases/tag/v${version}";
    description = "Live plot for PyqtGraph";
    homepage = "https://github.com/domarm-comat/pglive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
