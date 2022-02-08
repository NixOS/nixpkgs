{ lib
, buildPythonPackage
, fetchFromGitHub
, deprecated
, oauthlib
, requests
, requests_oauthlib
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "3.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = version;
    sha256 = "sha256-SJsqk8TM+5UztN1ZDyYrOjNIWDLhm5XtLxPflIGPxKQ=";
  };

  propagatedBuildInputs = [
    deprecated
    oauthlib
    requests
    requests_oauthlib
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "atlassian"
  ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
