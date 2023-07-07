{ lib
, buildPythonPackage
, fetchFromGitHub
, geojson
, pysocks
, pythonOlder
, requests
, pytestCheckHook
, pythonRelaxDepsHook
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
    hash = "sha256-cSOhm3aDksLBChZzgw1gjUjLQkElR2/xGFMOb9K9RME=";
  };

  pythonRelaxDeps = [
    "geojson"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    geojson
    pysocks
    requests
  ];

  nativeCheckInputs = [
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
