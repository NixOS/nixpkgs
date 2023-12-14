{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "goalzero";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h/EaEOe0zvnO5BYfcIyC3Vq8sPED6ts1IeI/GM+vm7c=";
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
