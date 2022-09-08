{ lib
, buildPythonPackage
, fetchFromGitHub
, deprecated
, oauthlib
, requests
, requests-oauthlib
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atlassian-python-api";
  version = "3.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-a0c/IOy14Pq8IEUKNyOh0/Z/ERGfeeI5aXFL/WpLUxE=";
  };

  propagatedBuildInputs = [
    deprecated
    oauthlib
    requests
    requests-oauthlib
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
