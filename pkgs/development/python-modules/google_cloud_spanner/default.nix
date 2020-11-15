{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, grpc_google_iam_v1, grpcio-gcp, google_api_core, google_cloud_core
, google_cloud_testutils, mock, pytest }:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "1.19.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b9ifh9i4hkcs19b4l6v8j8v93yd8p3j19qrrjvvf5a44bc7bhsh";
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
