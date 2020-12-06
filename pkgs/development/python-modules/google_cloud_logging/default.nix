{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, django
, flask, google_api_core, google_cloud_core, google_cloud_testutils, mock
, webapp2 }:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8e4869ec22aa7958ff937c1acbd34d7a2a8a446af9a09ce442f24128eee063c";
  };

  disabled = pythonOlder "3.5";

  checkInputs =
    [ django flask google_cloud_testutils mock pytestCheckHook webapp2 ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # api_url test broken, fix not yet released
  # https://github.com/googleapis/python-logging/pull/66
  disabledTests =
    [ "test_build_api_url_w_custom_endpoint" "test_write_log_entries" ];

  # prevent google directory from shadowing google imports
  # remove system integration tests
  preCheck = ''
    rm -r google
    rm tests/system/test_system.py
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/python-logging";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
