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
,setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OyfMbjxwtrYLrXrjCVS+DFjGdGGsMsfHBrGzg66crkU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    # Import is already tested
    "test_namespace_package_compat"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.error_reporting"
    "google.cloud.errorreporting_v1beta1"
  ];

  meta = with lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    changelog = "https://github.com/googleapis/python-error-reporting/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
