{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "niluclient";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OBoACPMlucfqyby/ACzlbwjBJX20d+Esy5BRkhmw1Yc=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "niluclient" ];

  meta = {
    description = "Python client for getting air pollution data from NILU sensor stations";
    homepage = "https://github.com/hfurubotten/niluclient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
