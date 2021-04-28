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
  version = "4.4.5";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "googlemaps";
    repo = "google-maps-services-python";
    rev = "v${version}";
    sha256 = "sha256-Rdfp98UqTMbqcOpkzh0Dz8fNSSbuvCnCztCkxiBgaAA=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # touches network
    "test_elevation_along_path_single"
    "test_transit_without_time"
  ];

  pythonImportsCheck = [ "googlemaps" ];

  meta = with lib; {
    homepage = "https://github.com/googlemaps/google-maps-services-python";
    description = "Python client library for Google Maps API Web Services";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
