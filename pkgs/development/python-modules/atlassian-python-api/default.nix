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
  version = "3.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ef384a91a790c807336e2bd6b7554284691aadd6d7413d199baf752dd84c53e";
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
