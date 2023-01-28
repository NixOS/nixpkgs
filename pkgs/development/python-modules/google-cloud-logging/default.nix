{ lib
, buildPythonPackage
, django
, fetchPypi
, flask
, google-api-core
, google-cloud-appengine-logging
, google-cloud-audit-log
, google-cloud-core
, google-cloud-testutils
, grpc-google-iam-v1
, mock
, pandas
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, rich
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zeD1n625F0aHRiUrr0sR6gD21obvAhORg+r5IfOu5rQ=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-appengine-logging
    google-cloud-audit-log
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    django
    flask
    google-cloud-testutils
    mock
    pandas
    pytestCheckHook
    pytest-asyncio
    rich
  ];

  disabledTests = [
    # requires credentials
    "test_write_log_entries"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests require credentials
    "tests/system/test_system.py"
    "tests/unit/test__gapic.py"
    # Exclude performance tests
    "tests/performance/test_performance.py"
  ];

  pythonImportsCheck = [
    "google.cloud.logging"
    "google.cloud.logging_v2"
  ];

  meta = with lib; {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/python-logging";
    changelog = "https://github.com/googleapis/python-logging/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
