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
  version = "3.2.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csparpa";
    repo = pname;
    rev = version;
    sha256 = "0sq8rxcgdiayl5gy4qhkvvsdq1d93sbzn0nfg8f1vr8qxh8qkfq4";
  };

  propagatedBuildInputs = [
    geojson
    pysocks
    requests
  ];

  checkInputs = [ pytestCheckHook ];

  # Run only tests which don't require network access
  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "pyowm" ];

  meta = with lib; {
    description = "Python wrapper around the OpenWeatherMap web API";
    homepage = "https://pyowm.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
