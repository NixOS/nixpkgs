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
  version = "4.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "googlemaps";
    repo = "google-maps-services-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-SwNUoC4x1Z+cqBvuBtDZNZMDcs4XwLj7LWntZ4gZ+vo=";
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
