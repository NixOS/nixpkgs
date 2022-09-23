{ lib
, buildPythonPackage
, fetchPypi
, django
, flask
, google-api-core
, google-cloud-appengine-logging
, google-cloud-audit-log
, google-cloud-core
, google-cloud-testutils
, mock
, pandas
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
, rich
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "3.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cZEhSRzDSe4/hGAPPCkWtbuV1oYLlNkNNPj2PZedEiA=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-appengine-logging
    google-cloud-audit-log
    google-cloud-core
    proto-plus
  ];

  checkInputs = [
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
    # requires credentials
    rm tests/system/test_system.py tests/unit/test__gapic.py
  '';

  pythonImportsCheck = [
    "google.cloud.logging"
    "google.cloud.logging_v2"
  ];

  meta = with lib; {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/python-logging";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
