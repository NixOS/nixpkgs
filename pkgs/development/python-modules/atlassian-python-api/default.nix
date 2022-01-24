{ lib
, buildPythonPackage
, fetchFromGitHub
, deprecated
, oauthlib
, requests
, requests_oauthlib
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = version;
    sha256 = "0akrwvq1f87lyckzwgpd16aljsbqjwwliv7j9czal7f216nbkvv6";
  };

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [ deprecated oauthlib requests requests_oauthlib six ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
