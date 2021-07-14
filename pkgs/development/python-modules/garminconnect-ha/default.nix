{ lib
, buildPythonPackage
, cloudscraper
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect-ha";
  version = "0.1.13";

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

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "garminconnect_ha" ];

  meta = with lib; {
    description = "Minimal Garmin Connect Python 3 API wrapper for Home Assistant";
    homepage = "https://github.com/cyberjunky/python-garminconnect-ha";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
