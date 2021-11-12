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
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2d9d730512fa6f64dd5223de12b8264a42c49cc73e06a58d6e4b6837346c682";
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
