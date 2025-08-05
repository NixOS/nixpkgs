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
  version = "4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UWIOAcSI8GXSA2Qly8HLz4ppcilRBf0oUyHrR+ZqMZ8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pyqt5 ];

  pythonImportsCheck = [ "pytestqt" ];

  # Tests require X server
  doCheck = false;

  meta = with lib; {
    description = "Pytest support for PyQt and PySide applications";
    homepage = "https://github.com/pytest-dev/pytest-qt";
    license = licenses.mit;
    maintainers = [ ];
  };
}
