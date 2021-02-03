{ lib, buildPythonPackage, fetchFromGitHub
, betamax
, betamax-serializers
, betamax-matchers
, mock
, six
, pytestrunner
, prawcore
, pytest
, requests-toolbelt
, update_checker
, websocket_client
}:

buildPythonPackage rec {
  pname = "praw";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "sha256-aEx0swjfyBrSu1fgIiAwdwWmk9v5o7sbT5HTVp7L3R4=";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

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
    mock
    pytest
    requests-toolbelt
    six
  ];

  meta = with lib; {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
