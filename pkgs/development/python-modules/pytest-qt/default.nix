{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytest,
  pyqt5,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dolhQqlApChTOQCNaSijbUvnSv7H5jRXfoQsnMXFaEQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pyqt5 ];

  pythonImportsCheck = [ "pytestqt" ];

  # Tests require X server
  doCheck = false;

  meta = with lib; {
    description = "pytest support for PyQt and PySide applications";
    homepage = "https://github.com/pytest-dev/pytest-qt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
