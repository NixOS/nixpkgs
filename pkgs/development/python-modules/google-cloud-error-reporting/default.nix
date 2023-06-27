{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-logging
, google-cloud-testutils
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "1.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3N7LtFKvTdV0zBGIyUgi6tCVZX7+rbJD5Lb+xZafJNw=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-logging
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Tests require credentials
    "test_report_error_event"
    "test_report_exception"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  meta = with lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    changelog = "https://github.com/googleapis/python-error-reporting/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
