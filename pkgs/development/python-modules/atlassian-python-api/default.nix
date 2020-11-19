{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, certifi
, chardet
, idna
, oauthlib
, requests
, requests_oauthlib
, six
, urllib3
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "1.17.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "456e9873fa5ab5cc91c6ae76a70b662f0993d32e4dff6d8febd866a53d86041e";
  };

  checkInputs = [ pytestrunner pytest ];

  propagatedBuildInputs = [ oauthlib requests requests_oauthlib six ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
