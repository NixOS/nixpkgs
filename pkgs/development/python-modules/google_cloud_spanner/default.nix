{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, grpc_google_iam_v1, grpcio-gcp, google_api_core, google_cloud_core
, google_cloud_testutils, mock, pytest }:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edac9d86ea2d8e87c048423f610cd3e5dbb6f9db7f1f9353ff133014689e97c6";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ google_cloud_testutils mock pytestCheckHook ];
  propagatedBuildInputs =
    [ grpcio-gcp grpc_google_iam_v1 google_api_core google_cloud_core ];

  # prevent google directory from shadowing google imports
  # remove tests that require credentials
  preCheck = ''
    rm -r google
    rm tests/system/test_system.py
  '';

  meta = with stdenv.lib; {
    description = "Cloud Spanner API client library";
    homepage = "https://pypi.org/project/google-cloud-spanner";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
