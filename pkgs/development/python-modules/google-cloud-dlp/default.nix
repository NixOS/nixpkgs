{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pytz
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6cf11b2d5ddbb931ba11060d0d0daa9188994be3ec9122f9bf24fccae8c907a";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus pytz ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # requires credentials
    "test_inspect_content"
  ];

  pythonImportsCheck = [
    "google.cloud.dlp"
    "google.cloud.dlp_v2"
  ];

  meta = with lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/python-dlp";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
