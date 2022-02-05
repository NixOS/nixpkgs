{ lib
, buildPythonPackage
, cloudscraper
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect-ha";
  version = "0.1.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect-ha";
    rev = version;
    sha256 = "sha256-1O1EcG5FvpwUvI8rwcdlQLzEEStyFAwvmkaL97u6hZ4=";
  };

  propagatedBuildInputs = [
    cloudscraper
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "garminconnect_ha"
  ];

  meta = with lib; {
    description = "Garmin Connect Python API wrapper for Home Assistant";
    homepage = "https://github.com/cyberjunky/python-garminconnect-ha";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
