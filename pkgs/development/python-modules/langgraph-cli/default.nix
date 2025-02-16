{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,

  # for update script
  langgraph-sdk,

  # testing
  pytest-asyncio,
  pytestCheckHook,
  docker-compose,

  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langgraph-cli";
  version = "0.1.71";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "cli==${version}";
    hash = "sha256-bTW+je4wuoR0YX5T1wdAee4w/T2jMTQybLLpCxouJxA=";
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

  passthru = {
    inherit (langgraph-sdk) updateScript;
    skipBulkUpdate = true; # Broken, see https://github.com/NixOS/nixpkgs/issues/379898
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
