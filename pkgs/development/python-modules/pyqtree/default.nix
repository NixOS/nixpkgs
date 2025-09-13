{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "pyqtree";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Pyqtree";
    inherit version;
    hash = "sha256-TzbVFg3fFw1yRenHECpFIRuFADOD3VUrbNEJ5QzDr4E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyqtree" ];

  meta = {
    changelog = "https://github.com/karimbahgat/Pyqtree/blob/v${version}/CHANGELOG.md";
    description = "Pure Python quad tree spatial index for GIS or rendering usage";
    homepage = "https://github.com/karimbahgat/Pyqtree";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hendrikheil ];
  };
}
