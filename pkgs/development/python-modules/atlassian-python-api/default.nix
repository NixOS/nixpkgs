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
  version = "1.15.7";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "b54cce1ca4bea838a949b4362410b1d717597951e5b7efbfa34ce89bc5df805e";
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

