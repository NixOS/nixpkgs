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
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff9933573dadb02176dc514662354949d0ea784cc4588d22226c2bf7eb90e797";
  };

  propagatedBuildInputs = [ grpc_google_iam_v1 google-api-core libcst proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
    # Tests in pubsub_v1 attempt to contact pubsub.googleapis.com
    rm -r tests/unit/pubsub_v1
  '';

  pythonImportsCheck = [ "google.cloud.pubsub" ];

  meta = with lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://pypi.org/project/google-cloud-pubsub";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
