{ lib
, buildPythonPackage
, cloudscraper
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.1.44";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    rev = version;
    hash = "sha256-CUjMbh3eGPwoHW+oOjaVyr0g/txWmzGuP1usq2WCwZg=";
  };

  propagatedBuildInputs = [
    cloudscraper
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "garminconnect"
  ];

  meta = with lib; {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
