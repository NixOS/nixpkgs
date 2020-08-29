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
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b672131be7cc5e239c465909454542623c0aeb0a4d3b05e6a25ee9459959c11d";
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
