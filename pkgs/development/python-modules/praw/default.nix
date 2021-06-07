{ lib
, buildPythonPackage
, fetchFromGitHub
, betamax
, betamax-serializers
, betamax-matchers
, mock
, prawcore
, pytestCheckHook
, requests-toolbelt
, update_checker
, websocket_client
}:

buildPythonPackage rec {
  pname = "praw";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/GV5ZhrJxeChcYwmH/9FsLceAYRSeTCDe4lMEwdTa8Y=";
  };

  propagatedBuildInputs = [
    mock
    prawcore
    update_checker
    websocket_client
  ];

  checkInputs = [
    betamax
    betamax-serializers
    betamax-matchers
    pytestCheckHook
    requests-toolbelt
  ];

  pythonImportsCheck = [ "praw" ];

  meta = with lib; {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
