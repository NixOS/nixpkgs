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
<<<<<<< HEAD
  version = "3.41.1";
=======
  version = "3.34.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "atlassian-api";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-DSIJOp5c/bqOOIZylhUGyIwIco5isA3ytCRR51WfTyI=";
=======
    hash = "sha256-en+4EKkmTQWMgnGZaGs+O9Yh2TI03xW111wbp9O8dYE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    deprecated
    oauthlib
    requests
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
<<<<<<< HEAD
    changelog = "https://github.com/atlassian-api/atlassian-python-api/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
