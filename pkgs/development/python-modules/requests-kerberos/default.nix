{ lib
, fetchFromGitHub
, buildPythonPackage
, cryptography
, requests
, pykerberos
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "requests-kerberos";
  version = "0.12.0";

  # tests are not present in the PyPI version
  src = fetchFromGitHub {
    owner = "requests";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qw96aw84nljh9cip372mfv50p1yyirfgigavvavgpc3c5g278s6";
  };

  propagatedBuildInputs = [
    cryptography
    requests
    pykerberos
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  # they have a setup.py which mentions a test suite that doesn't exist...
  patches = [ ./fix_setup.patch ];

  pythonImportsCheck = [ "requests_kerberos" ];

  meta = with lib; {
    description = "An authentication handler for using Kerberos with Python Requests";
    homepage = "https://github.com/requests/requests-kerberos";
    license = licenses.isc;
    maintainers = with maintainers; [ catern ];
  };
}
