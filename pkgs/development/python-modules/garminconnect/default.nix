{ lib
, buildPythonPackage
, cloudscraper
, fetchFromGitHub
, garth
, pdm-backend
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.2.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    rev = "refs/tags/${version}";
    hash = "sha256-hyrj3icj5QxXf9NDk/x7bocFg6iD+KEDZNcpZVBEx4k=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    cloudscraper
    garth
    requests
  ];

  # Tests require a token
  doCheck = false;

  pythonImportsCheck = [
    "garminconnect"
  ];

  meta = with lib; {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
