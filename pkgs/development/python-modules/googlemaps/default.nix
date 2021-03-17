{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, responses
, pytestCheckHook
, pytestcov
, isPy27
}:

buildPythonPackage rec {
  pname = "googlemaps";
  version = "4.4.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "googlemaps";
    repo = "google-maps-services-python";
    rev = "v${version}";
    sha256 = "0038c0hcd96hrv12kg7f4r4wviyg0cfwwr7af3mcck1aqpvykms5";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook responses pytestcov ];

  disabledTests = [
    # touches network
    "test_elevation_along_path_single"
    "test_transit_without_time"
  ];

  meta = with lib; {
    homepage = "https://github.com/googlemaps/google-maps-services-python";
    description = "Python client library for Google Maps API Web Services";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
