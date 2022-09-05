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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jNsIpg5M8r7SfzldmcsAqoyKI/7pwwo/Zk7KBwdOxJQ=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
    pytz
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

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
