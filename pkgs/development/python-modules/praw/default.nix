{
  lib,
  betamax-matchers,
  betamax-serializers,
  betamax,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mock,
  prawcore,
  pytestCheckHook,
  pythonOlder,
  requests-toolbelt,
  update-checker,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "praw";
  version = "7.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    tag = "v${version}";
    hash = "sha256-jxF7rlMwKIKwyYv35vYWAdtClsVhnIkywoyMQeggGBc=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mock
    prawcore
    update-checker
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

  pythonImportsCheck = [ "praw" ];

  meta = with lib; {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    changelog = "https://github.com/praw-dev/praw/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
