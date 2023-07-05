{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-cov
, pytestCheckHook
, pythonOlder
, requests
, responses
}:

buildPythonPackage rec {
  pname = "googlemaps";
  version = "4.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "googlemaps";
    repo = "google-maps-services-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-8oGZEMKUGaDHKq4qIZy10cbLNMmVclJnQE/dx877pNQ=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # touches network
    "test_elevation_along_path_single"
    "test_transit_without_time"
  ];

  pythonImportsCheck = [
    "googlemaps"
  ];

  meta = with lib; {
    description = "Python client library for Google Maps API Web Services";
    homepage = "https://github.com/googlemaps/google-maps-services-python";
    changelog = "https://github.com/googlemaps/google-maps-services-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
