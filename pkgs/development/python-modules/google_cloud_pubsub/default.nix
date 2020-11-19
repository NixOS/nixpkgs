{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytestCheckHook
, google_api_core, google_cloud_testutils, grpc_google_iam_v1, libcst, mock
, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0358g5q4igq1pgy8dznbbkc6y7zf36y4m81hhh8hvzzhaa37vc22";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];
  propagatedBuildInputs =
    [ grpc_google_iam_v1 google_api_core libcst proto-plus ];

  # prevent google directory from shadowing google imports
  # Tests in pubsub_v1 attempt to contact pubsub.googleapis.com
  preCheck = ''
    rm -r google
    rm -r tests/unit/pubsub_v1
  '';

  pythonImportsCheck = [ "google.cloud.pubsub" ];

  meta = with stdenv.lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://pypi.org/project/google-cloud-pubsub";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
