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
  version = "1.15.4";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0vkq3sr4a23ipk74swsmc3ydg3q91asixb7hzl8mzkfpgnnyvr77";
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

