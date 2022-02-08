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
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = version;
    sha256 = "sha256-SJsqk8TM+5UztN1ZDyYrOjNIWDLhm5XtLxPflIGPxKQ=";
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
