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
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a4ad2832be3b86c8f0fb57b2d382a1f67218137c6f6051372647ac5147d6421";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "google-cloud-appengine-logging >= 0.1.0, < 1.0.0dev" "google-cloud-appengine-logging >= 0.1.0"
  '';

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
