{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langgraph-cli";
  version = "0.2.28";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/${version}";
    hash = "sha256-RbV4G5YPAUjS20B1sQsmFGBje1pbxgCu81pCESFbJLs=";
  };

  sourceRoot = "${src.name}/libs/cli";

  build-system = [ poetry-core ];

  dependencies = [ click ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langgraph_cli" ];

  disabledTests = [
    # Flaky tests that generate a Docker configuration then compare to exact text
    "test_config_to_docker_simple"
    "test_config_to_docker_pipconfig"
    "test_config_to_compose_env_vars"
    "test_config_to_compose_env_file"
    "test_config_to_compose_end_to_end"
    "test_config_to_compose_simple_config"
    "test_config_to_compose_watch"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cli==(.*)"
    ];
  };

  meta = {
    description = "Official CLI for LangGraph API";
    homepage = "https://github.com/langchain-ai/langgraph/libs/cli";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${version}";
    mainProgram = "langgraph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
