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
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PtAKi9IHb+56HcBTiA/LPJcxhIB+JA+MPAkp3XSOr38=";
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
    pytestCheckHook
    pytest-asyncio
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
