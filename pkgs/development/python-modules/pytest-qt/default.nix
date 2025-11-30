{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytest,
  pluggy,
  typing-extensions,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-qt";
    tag = version;
    hash = "sha256-ZCWWhd1/7qdSgGLNbsjPlxg24IFdqbNtLRktgMFVCJY=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [
    pluggy
    typing-extensions
  ];

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
