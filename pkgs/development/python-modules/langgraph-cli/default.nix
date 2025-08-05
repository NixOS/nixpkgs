{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  click,
  langgraph-sdk,

  # testing
  pytest-asyncio,
  pytestCheckHook,
  docker-compose,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-cli";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-UY3AChShKfOrtOQzOm5vi3Yy3rlBc+TAje9L2L6My/U=";
  };

  sourceRoot = "${src.name}/libs/cli";

  build-system = [ hatchling ];

  dependencies = [
    click
    langgraph-sdk
  ];

  # Not yet. Depemnds on `langgraph-runtime-inmem` which isn't in github yet
  # https://github.com/langchain-ai/langgraph/issues/5802
  # optional-dependencies = {
  #   "inmem" = [
  #     langgraph-api
  #     langgraph-runtime-inmem
  #     python-dotenv
  #   ]
  # }

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    docker-compose
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

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

    # Tests that require docker
    "test_dockerfile_command_with_docker_compose"
    "test_build_command_with_api_version_and_base_image"
    "test_build_command_with_api_version"
    "test_build_generate_proper_build_context"
    "test_build_command_shows_wolfi_warning"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "cli==";
  };

  meta = {
    description = "Official CLI for LangGraph API";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/cli";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    mainProgram = "langgraph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
