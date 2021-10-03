{ lib
, buildPythonPackage
, fetchPypi
, mock
, google-api-core
, google-cloud-testutils
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-videointelligence";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb3a98b5b8044be80c5fdbd76e7acd9b9bdd6026729a53eae9692a9a6c6683ef";
  };

  propagatedBuildInputs = [ google-api-core proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

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
