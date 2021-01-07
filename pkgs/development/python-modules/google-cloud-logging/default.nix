{ stdenv
, buildPythonPackage
, fetchPypi
, django
, flask
, google-api-core
, google-cloud-core
, google-cloud-testutils
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, webapp2
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s09vs4rnq4637j8zw7grv3f4j7njqprm744b1knzldj91rg0vmi";
  };

  propagatedBuildInputs = [ google-api-core google-cloud-core proto-plus ];

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

  pythonImortsCheck = [
    "google.cloud.logging"
    "google.cloud.logging_v2"
  ];

  meta = with stdenv.lib; {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/python-logging";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
