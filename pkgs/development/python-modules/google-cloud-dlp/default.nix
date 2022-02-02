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
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20abce8d8d3939db243cbc0da62a73ff1a4e3b3b341f7ced0cfeb5e2c4a66621";
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
