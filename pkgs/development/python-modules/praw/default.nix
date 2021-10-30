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
, websocket-client
}:

buildPythonPackage rec {
  pname = "praw";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wcr59k1bncwfza5k8mllaxz8fwfyqbwgm5xp908w2449i71wl7r";
  };

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
