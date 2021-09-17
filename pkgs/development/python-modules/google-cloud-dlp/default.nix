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
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZxGWTsqCIvpTSN+aThVgjPuMJE7hHMVn4zsidpXk7xk=";
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
