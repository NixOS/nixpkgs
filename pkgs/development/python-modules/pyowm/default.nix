{ lib
, buildPythonPackage
, fetchFromGitHub
, geojson
, pysocks
, pythonOlder
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyowm";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csparpa";
    repo = pname;
    rev = version;
    sha256 = "sha256-cSOhm3aDksLBChZzgw1gjUjLQkElR2/xGFMOb9K9RME=";
  };

  propagatedBuildInputs = [
    geojson
    pysocks
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Run only tests which don't require network access
  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [
    "pyowm"
  ];

  meta = with lib; {
    description = "Python wrapper around the OpenWeatherMap web API";
    homepage = "https://pyowm.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
