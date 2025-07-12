{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pyvirtualdisplay,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-xvfb";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "pytest_xvfb";
    inherit version;
    hash = "sha256-kFk2NEJ9l0snLoRXk+RTP1uCfJ2EwFGHkBNiRQQXXkQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ pyvirtualdisplay ];

  meta = with lib; {
    description = "Pytest plugin to run Xvfb for tests";
    homepage = "https://github.com/The-Compiler/pytest-xvfb";
    changelog = "https://github.com/The-Compiler/pytest-xvfb/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
