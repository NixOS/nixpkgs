{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, libcst
, proto-plus
, pytestCheckHook
, pytest-asyncio
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e59e3f8d45f20650b5be9bb04bb74fad3445c3596a7fe1868e6d9fa857c83a34";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

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
