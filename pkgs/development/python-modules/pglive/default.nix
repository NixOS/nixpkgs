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
  version = ".0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domarm-comat";
    repo = "pglive";
    tag = "v${version}";
    hash = "sha256-/z4hpWqxW4WkHa9SXfu7UXHoNrVpbqR7+YbsRQUuEA8=";
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
    "pyqtgraph"
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
