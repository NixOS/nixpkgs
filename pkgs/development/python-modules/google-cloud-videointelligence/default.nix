{ lib
, buildPythonPackage
, fetchPypi
, mock
, google-api-core
, google-cloud-testutils
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-videointelligence";
  version = "2.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NqElDocBlpARYFTK4k47kCsC/7D1048rNYrrARHeWmg=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

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

  meta = with lib; {
    description = "Google Cloud Video Intelligence API client library";
    homepage = "https://github.com/googleapis/python-videointelligence";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
