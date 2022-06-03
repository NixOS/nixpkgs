{ lib
, buildPythonPackage
, docutils
, fetchPypi
, psutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynisher";
  version = "0.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ER2RqtRxN1wFCakSQV/5AFPvkJEA+s9BJRE4OvEHwSQ=";
  };

  propagatedBuildInputs = [
    psutil
    docutils
  ];

  # No tests in the Pypi archive
  doCheck = false;

  pythonImportsCheck = [
    "pynisher"
  ];

  meta = with lib; {
    description = "Module intended to limit a functions resources";
    homepage = "https://github.com/sfalkner/pynisher";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
