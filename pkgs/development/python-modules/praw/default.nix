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
  version = "7.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y2eynMsjF4wZd31YoLdtk8F+ga7Z3R+IQkQK0x0RAGA=";
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

  pythonImportsCheck = [
    "praw"
  ];

  meta = with lib; {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
