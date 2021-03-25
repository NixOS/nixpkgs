{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, certifi
, chardet
, deprecated
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
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f852bfd293fdcb0ab2d7a9ea907f8303cf14fe6f55e90c103d4de00393ea9555";
  };

  checkInputs = [ pytestrunner pytest ];

  propagatedBuildInputs = [ deprecated oauthlib requests requests_oauthlib six ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
