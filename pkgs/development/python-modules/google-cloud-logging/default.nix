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
<<<<<<< HEAD
  version = "3.6.0";
=======
  version = "3.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-QhNCI5VoUN3WSHfIgELTH3hljnsGelqOPdKCNrcfPDI=";
=======
    hash = "sha256-8RVEoh6jVW9w66x7wzj/qKGXkTg07N2IU9F2uHCCOqo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
