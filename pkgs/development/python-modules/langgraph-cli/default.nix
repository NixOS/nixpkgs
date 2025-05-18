{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  click,

  # testing
  pytest-asyncio,
  pytestCheckHook,
  docker-compose,

  # passthru
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langgraph-cli";
  version = "0.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "cli==${version}";
    hash = "sha256-gSiyFjk1lXiCv7JpX4J00WAPoMv4VsXDuCswbFhP2kY=";
  };

  sourceRoot = "${src.name}/libs/cli";

  build-system = [ poetry-core ];

  dependencies = [ click ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    docker-compose
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
    # Tests exit value, needs to happen in a passthru test
    "test_dockerfile_command_with_docker_compose"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cli==(\\d+\\.\\d+\\.\\d+)"
    ];
  };

  meta = {
    description = "Official CLI for LangGraph API";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/cli";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${version}";
    mainProgram = "langgraph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
