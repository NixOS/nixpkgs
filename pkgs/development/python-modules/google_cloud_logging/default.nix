{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, django
, flask, google_api_core, google_cloud_core, google_cloud_testutils, mock
, webapp2 }:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb0d4af9d684eb8a416f14c39d9fa6314be3adf41db2dd8ee8e30db9e8853d90";
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
