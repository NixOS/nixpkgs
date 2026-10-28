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

buildPythonPackage (finalAttrs: {
  pname = "praw";
  version = "7.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mAXRLo8xBTigtXYRbc6qxjjoRJ0+v0DZeLEwLISh2PE=";
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
    changelog = "https://github.com/praw-dev/praw/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
