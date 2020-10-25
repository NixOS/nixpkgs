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
  version = "1.17.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c54ebb385eeb18c6275091687ad1f21e5e91613b6aca31b6727e880a678d16c2";
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
