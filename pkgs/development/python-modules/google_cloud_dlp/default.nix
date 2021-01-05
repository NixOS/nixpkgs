{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_testutils
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09rnzpdlycr1wv8agcfx05v1prn35ylphsbr07486zqdkh5wjk8p";
  };

  propagatedBuildInputs = [ google_api_core libcst proto-plus ];

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_inspect_content"
  ];

  pythonImportsCheck = [
    "google.cloud.dlp"
    "google.cloud.dlp_v2"
  ];

  meta = with stdenv.lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/python-dlp";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
