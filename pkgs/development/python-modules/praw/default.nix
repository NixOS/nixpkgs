{ stdenv, buildPythonPackage, fetchFromGitHub
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
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "0d5whaw4731gllffhwrh2qqnlki4j8q83xaf3v4spkd40ps3q7b4";
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

  meta = with stdenv.lib; {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
