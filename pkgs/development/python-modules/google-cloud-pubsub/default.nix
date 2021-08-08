{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, google-cloud-testutils
, grpc_google_iam_v1
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8706557b71532c76aec48409dcac189caac47cf2decb8850ae75694bf70326b2";
  };

  propagatedBuildInputs = [
    grpc_google_iam_v1
    google-api-core
    libcst
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests in pubsub_v1 attempt to contact pubsub.googleapis.com
    "tests/unit/pubsub_v1"
  ];

  pythonImportsCheck = [ "google.cloud.pubsub" ];

  meta = with lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://pypi.org/project/google-cloud-pubsub";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
