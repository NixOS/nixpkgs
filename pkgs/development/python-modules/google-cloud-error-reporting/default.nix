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
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a7d742ab1c94525a68c75c94ccb7af3f19759627ebe7869fe16db158f0eba4e";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'google-cloud-logging>=1.14.0, <2.4' 'google-cloud-logging>=1.14.0'
  '';

  propagatedBuildInputs = [
    google-cloud-logging
    libcst
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # require credentials
    "test_report_error_event"
    "test_report_exception"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  meta = with lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
