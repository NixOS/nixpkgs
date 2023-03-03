{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, packaging
, quantities
, pythonOlder
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O2yk/AXf206VPiU+cJlL+7yP4ukJWPvaf6WGDK8/pjo=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    quantities
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    nosetests --exclude=iotest
  '';

  pythonImportsCheck = [
    "neo"
  ];

  meta = with lib; {
    description = "Package for representing electrophysiology data";
    homepage = "https://neuralensemble.org/neo/";
    changelog = "https://neo.readthedocs.io/en/${version}/releases/${version}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
