{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
  pdm-backend,
  pythonOlder,
  requests,
  withings-sync,
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.2.31";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    tag = version;
    hash = "sha256-yK4p1zb3OLTpDrtVz0bA/jlhDV3AFpltN3CTDBcSTPU=";
  };

  pythonRelaxDeps = [
    "garth"
    "withings-sync"
  ];

  build-system = [ pdm-backend ];

  dependencies = [
    garth
    requests
    withings-sync
  ];

  # Tests require a token
  doCheck = false;

  pythonImportsCheck = [ "garminconnect" ];

  meta = with lib; {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
