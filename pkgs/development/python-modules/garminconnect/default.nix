{ lib
, buildPythonPackage
, cloudscraper
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.1.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect-ha";
    rev = version;
    hash = "sha256-1O1EcG5FvpwUvI8rwcdlQLzEEStyFAwvmkaL97u6hZ4=";
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
