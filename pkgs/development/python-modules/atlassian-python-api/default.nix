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
  version = "1.17.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbd7941fa7e1eb6f63e12724277894350298745480297658da912e07234314cc";
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
