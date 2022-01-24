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
  version = "4.5.3";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "googlemaps";
    repo = "google-maps-services-python";
    rev = "v${version}";
    sha256 = "1yfsfspvjngrb1lwaq04ahm94j9y2dwzdf4dsg3yl1c8w0vgf9yw";
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
