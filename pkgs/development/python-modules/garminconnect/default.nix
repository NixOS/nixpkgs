{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
  pdm-backend,
  requests,
  withings-sync,
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.2.38";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    tag = version;
    hash = "sha256-d2R/ir/dxFnC4ZjLBHP+mm9JMtfPZ9VMxSRv35rE+CU=";
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

  meta = {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
