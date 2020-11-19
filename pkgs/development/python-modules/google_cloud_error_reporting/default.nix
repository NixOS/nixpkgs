{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_cloud_logging, google_cloud_testutils, libcst, mock, proto-plus
, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y5vkkg1cmzshj5j68zk1876857z8a7sjm0wqhf4rzgqgkr2kcdd";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];
  propagatedBuildInputs = [ google_cloud_logging libcst proto-plus ];

  # Disable tests that require credentials
  disabledTests = [ "test_report_error_event" "test_report_exception" ];
  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
