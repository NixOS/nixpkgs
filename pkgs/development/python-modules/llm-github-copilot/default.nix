{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-github-copilot,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-github-copilot";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmdaly";
    repo = "llm-github-copilot";
    tag = version;
    hash = "sha256-BKbDhsW6gIZVcQvkUB5TKmNqQzIjQTMMhNZiO9VWO3s=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # The following tests fail on darwin even with the writableTmpDirAsHomeHook
    # nativeCheckInput, because the code path they test calls methods from the
    # llm package, which use os.path.expanduser. Despite the documentation for
    # os.path.expanduser stating that
    # "an initial ~ is replaced by the environment variable HOME if it is set"
    # somehow neither $HOME or a $LLM_USER_PATH variable exported in the
    # preCheck phase resolve the issue:
    # Operation not permitted: '/var/empty/Library'
    "test_prompt"
    "test_model_variants"
    "test_options"
    "test_authenticator"
    "test_authenticator_has_valid_credentials"
    "test_authenticator_get_access_token"
  ];

  pythonImportsCheck = [ "llm_github_copilot" ];

  passthru.tests = llm.mkPluginTest llm-github-copilot;

  meta = {
    description = "LLM plugin providing access to GitHub Copilot";
    homepage = "https://github.com/jmdaly/llm-github-copilot";
    changelog = "https://github.com/jmdaly/llm-github-copilot/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ afh ];
  };
}
