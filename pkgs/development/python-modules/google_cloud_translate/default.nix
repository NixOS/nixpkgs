{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_api_core, google_cloud_core, google_cloud_testutils, grpcio, libcst
, mock, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-translate";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6183168465749f007449ef4125356d03cca0114ed49faf7ed64f34ec3edd4fe8";
  };

  disabled = pythonOlder "3.6";

  # google_cloud_core[grpc] -> grpcio
  propagatedBuildInputs =
    [ google_api_core google_cloud_core grpcio libcst proto-plus ];

  checkInputs = [ google_cloud_testutils mock pytest-asyncio pytestCheckHook ];

  # test_http.py broken, fix not yet released
  # https://github.com/googleapis/python-translate/pull/69
  disabledTests = [
    "test_build_api_url_w_extra_query_params"
    "test_build_api_url_no_extra_query_params"
    "test_build_api_url_w_custom_endpoint"
  ];

  preCheck = ''
    rm -r google
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Translation API client library";
    homepage = "https://github.com/googleapis/python-translate";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
