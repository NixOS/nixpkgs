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
  version = "1.14.9";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "28ff793cb43152384a810efc6ee572473daf3dc44bf7c1c295efb270a6d29251";
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

