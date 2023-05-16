{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
, pyqt5
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AKF7WG3VMLbXqTmZI6QEicpKmjCXGQERdfVdxrXcj0E=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pyqt5
  ];

  pythonImportsCheck = [
    "pytestqt"
  ];

  # Tests require X server
  doCheck = false;

  meta = with lib; {
    description = "pytest support for PyQt and PySide applications";
    homepage = "https://github.com/pytest-dev/pytest-qt";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
