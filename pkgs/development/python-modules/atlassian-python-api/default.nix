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
  version = "1.16.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "1sp036192vdl5nqifcswg2j838vf8i9k8bfd0w4qh1vz4f0pjz7y";
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

