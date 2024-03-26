{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, deprecated
, jmespath
, lxml
, oauthlib
, requests
, requests-kerberos
, requests-oauthlib
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "3.41.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yQqy+pFl5TK4CEUM+vpwl+pkUjBuc0xvqC9o1ZC5m7c=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    deprecated
    jmespath
    lxml
    oauthlib
    requests
    requests-kerberos
    requests-oauthlib
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "atlassian"
  ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    changelog = "https://github.com/atlassian-api/atlassian-python-api/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
