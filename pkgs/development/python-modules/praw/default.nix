{
  lib,
  betamax-matchers,
  betamax-serializers,
  betamax,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  flit-core,
  mock,
  prawcore,
  pytestCheckHook,
  requests-toolbelt,
  update-checker,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "praw";
  version = "7.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    tag = "v${version}";
    hash = "sha256-jxF7rlMwKIKwyYv35vYWAdtClsVhnIkywoyMQeggGBc=";
  };

  patches = [
    # fix tests under python 3.14
    (fetchpatch {
      url = "https://github.com/praw-dev/praw/commit/9edc0bfa62c1878c395d8bc225edfe87e4fc4cd4.patch";
      includes = [ "tests/unit/test_reddit.py" ];
      hash = "sha256-QozdHz8WPCsuBgFgx1j0NwFsPFBmq9KhKiW7B5/QmfE=";
    })
  ];

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

  meta = {
    description = "Python Reddit API wrapper";
    homepage = "https://praw.readthedocs.org/";
    changelog = "https://github.com/praw-dev/praw/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
