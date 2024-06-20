{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  numpy,
  packaging,
  quantities,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gVhbKLZaTciakucc7TlCxdv9qnG90sw4U3G3ebVlTK0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    packaging
    quantities
  ];

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests --exclude=iotest
  '';

  pythonImportsCheck = [ "neo" ];

  meta = with lib; {
    description = "Package for representing electrophysiology data";
    homepage = "https://neuralensemble.org/neo/";
    changelog = "https://neo.readthedocs.io/en/${version}/releases/${version}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
