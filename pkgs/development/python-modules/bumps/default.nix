{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J8NeV9FCUC5dLkosBzVrovxiJJbeuj8Xc50NGEI9Bms=";
  };

  propagatedBuildInputs = [
    six
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "bumps"
  ];

  meta = with lib; {
    description = "Data fitting with bayesian uncertainty analysis";
    homepage = "https://bumps.readthedocs.io/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rprospero ];
  };
}
