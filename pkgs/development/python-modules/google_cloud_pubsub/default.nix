{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytestCheckHook
, google_api_core, google_cloud_testutils, grpc_google_iam_v1, libcst, mock
, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc50a60803f5c409a295ec0e31cdd4acc271611ce3f4963a072036bbfa5ccde5";
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
