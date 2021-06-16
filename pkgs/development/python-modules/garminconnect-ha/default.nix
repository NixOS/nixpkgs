{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect-ha";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect-ha";
    rev = version;
    sha256 = "0ngas6zikhpja1cdkq64m9pjm4b0z3qaj9g3x88mggy60jsxm1d7";
  };

  propagatedBuildInputs = [
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
