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
  version = "7.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-L7wTHD/ypXVc8GMfl9u16VNb9caLJoXpaMEIzaVVUgo=";
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

  disabledTestPaths = [
    # tests requiring network
    "tests/integration"
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
