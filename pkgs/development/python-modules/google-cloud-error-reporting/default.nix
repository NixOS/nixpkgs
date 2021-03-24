{ lib
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
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cba8409f6e2c9822e7034c10fe1b1f7e566e1affa66e8be91badae69962142f9";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'google-cloud-logging>=1.14.0, <2.1' 'google-cloud-logging>=1.14.0'
  '';

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

  meta = with lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
