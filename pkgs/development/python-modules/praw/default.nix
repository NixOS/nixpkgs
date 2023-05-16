{ lib
, betamax
, betamax-matchers
, betamax-serializers
, buildPythonPackage
, fetchFromGitHub
, mock
, prawcore
, pytestCheckHook
, pythonOlder
, requests-toolbelt
, update_checker
, websocket-client
}:

buildPythonPackage rec {
  pname = "praw";
<<<<<<< HEAD
  version = "7.7.1";
=======
  version = "7.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-L7wTHD/ypXVc8GMfl9u16VNb9caLJoXpaMEIzaVVUgo=";
=======
    hash = "sha256-reJW1M1yDSQ1SvZJeOc0jwHj6ydl1AmMl5VZqRHxXZA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    mock
    prawcore
    update_checker
    websocket-client
  ];

  nativeCheckInputs = [
    betamax
    betamax-serializers
    betamax-matchers
    pytestCheckHook
    requests-toolbelt
  ];

  pythonImportsCheck = [
    "praw"
  ];

  meta = with lib; {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    changelog = "https://github.com/praw-dev/praw/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
