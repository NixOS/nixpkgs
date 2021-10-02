{ lib, buildPythonPackage, fetchFromGitHub
, betamax
, betamax-serializers
, betamax-matchers
, mock
, six
, pytest-runner
, prawcore
, pytest
, requests-toolbelt
, update_checker
, websocket-client
}:

buildPythonPackage rec {
  pname = "praw";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "0by89aw7m803dvjcc33m9390msjm6v5v8g3k8ink9gfm421lw8ky";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    mock
    prawcore
    update_checker
    websocket-client
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
