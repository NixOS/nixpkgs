{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  deprecated,
  jmespath,
  lxml,
  oauthlib,
  requests,
  requests-kerberos,
  requests-oauthlib,
  six,
  typing-extensions,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "4.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = "atlassian-python-api";
    tag = version;
    hash = "sha256-po3oW6ncHx6uSFIGJUkbrevvgmvTiJ3eVLeNbYuc1us=";
  };

  dependencies = [
    beautifulsoup4
    deprecated
    jmespath
    lxml
    oauthlib
    requests
    requests-kerberos
    requests-oauthlib
    six
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "atlassian" ];

  meta = with lib; {
    description = "Python Atlassian REST API Wrapper";
    homepage = "https://github.com/atlassian-api/atlassian-python-api";
    changelog = "https://github.com/atlassian-api/atlassian-python-api/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
