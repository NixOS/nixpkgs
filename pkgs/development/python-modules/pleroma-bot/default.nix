{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests-mock,
  oauthlib,
  requests-oauthlib,
  requests,
  pyaml,
  setuptools,
  feedparser,
  beautifulsoup4,
  tqdm,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "pleroma-bot";
  version = "1.2.0";
  pyproject = true;
  build-system = [ setuptools ];
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "robertoszek";
    repo = "pleroma-bot";
    tag = finalAttrs.version;
    hash = "sha256-my42szvkiUg6vGG6yGjDqN5LlDaertj+yA/pIcjdaLk=";
  };

  dependencies = [
    pyaml
    requests
    requests-oauthlib
    oauthlib
    feedparser
    beautifulsoup4
    tqdm
  ];

  postPatch = ''
    substituteInPlace pleroma_bot/tests/test_{exceptions,logger}.py --replace-fail 'return' 'assert'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    # Tries to connect to api.twitter.com
    "pleroma_bot/tests/test_run.py::test_tweet_order"
    # Tries to connect to api.twitter.com and pbs.twimg.com
    "pleroma_bot/tests/test_run.py::test_main"
  ];

  pythonImportsCheck = [ "pleroma_bot" ];

  meta = {
    description = "Bot for mirroring one or multiple Twitter accounts in Pleroma/Mastodon";
    mainProgram = "pleroma-bot";
    homepage = "https://robertoszek.github.io/pleroma-bot/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ robertoszek ];
    broken = python.pythonAtLeast "3.15";
  };
})
