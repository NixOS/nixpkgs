{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, google_api_core
, google_cloud_testutils
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-videointelligence";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yhmizig41ymr2dz0i6ccrwszp0ivyykmq11vqxp82l9ncjima82";
  };

  propagatedBuildInputs = [ google_api_core proto-plus ];

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # require credentials
    "test_annotate_video"
  ];

  pythonImportsCheck = [
    "google.cloud.videointelligence"
    "google.cloud.videointelligence_v1"
    "google.cloud.videointelligence_v1beta2"
    "google.cloud.videointelligence_v1p1beta1"
    "google.cloud.videointelligence_v1p2beta1"
    "google.cloud.videointelligence_v1p3beta1"
  ];

  meta = with stdenv.lib; {
    description = "Google Cloud Video Intelligence API client library";
    homepage = "https://github.com/googleapis/python-videointelligence";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
