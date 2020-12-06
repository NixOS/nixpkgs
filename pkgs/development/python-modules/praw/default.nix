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
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "07wyn2pa80ps55kk66rvf4daqyn3y5lzxhx6qh1lpn3p2bacbw9h";
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
