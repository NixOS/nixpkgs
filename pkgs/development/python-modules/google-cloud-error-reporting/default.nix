{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-cloud-logging
, google-cloud-testutils
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fd6fe25343f7017c22e2733a0358c64b3171edc1669d0c8a1e1f07f86a048c4";
  };

  propagatedBuildInputs = [ google-cloud-logging libcst proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  disabledTests = [
    # require credentials
    "test_report_error_event"
    "test_report_exception"
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
