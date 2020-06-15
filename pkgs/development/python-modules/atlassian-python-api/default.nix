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
  version = "1.15.9";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "c6a3125ee68ecf4d11947497c1f891b6436df9d8453f8865cabf595813504cc1";
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

