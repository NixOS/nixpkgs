{
  lib,
  buildPythonPackage,
  pytest,
  fetchPypi,
  setuptools,
  wheel,
  mock,
}:

buildPythonPackage rec {
  pname = "polling";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "polling";
    hash = "sha256-wPH4BIQ/544J9vxt5vuLEfc74KzOnN4mKxjkp61ABaY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    mock
    pytest
  ];

  pythonImportsCheck = [ "polling" ];

  meta = {
    description = "Powerful polling utility in Python";
    homepage = "https://github.com/justiniso/polling";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
