{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "goalzero";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PveHE317p5fGSxgx7LQkpRYF55HwdzpZFY8/F8s3CBQ=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "goalzero"
  ];

  meta = with lib; {
    description = "Goal Zero Yeti REST Api Library";
    homepage = "https://github.com/tkdrob/goalzero";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
