{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  azure-core,
  azure-identity,
  langchain-core,
  requests,

  # tests
  freezegun,
  lark,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-azure-dynamic-sessions";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-azure";
    tag = "libs/azure-dynamic-sessions/v${finalAttrs.version}";
    hash = "sha256-kxj1LotC3MgdWHuOpWHNJvjuCvd/nyLDvmgvm42aA/k=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/azure-dynamic-sessions";

  postPatch = ''
    sed -i -E 's/"uv_build[^"]*"/"uv_build"/' pyproject.toml
  '';

  build-system = [ uv-build ];

  pythonRelaxDeps = [ "langchain-core" ];

  dependencies = [
    azure-core
    azure-identity
    langchain-core
    requests
  ];

  nativeCheckInputs = [
    freezegun
    lark
    pandas
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_azure_dynamic_sessions" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "libs/azure-dynamic-sessions/v";
      ignoredVersions = "a|b|dev|rc";
    };
  };

  meta = {
    description = "Integration package connecting Azure Container Apps dynamic sessions and LangChain";
    homepage = "https://github.com/langchain-ai/langchain-azure/tree/main/libs/azure-dynamic-sessions";
    changelog = "https://github.com/langchain-ai/langchain-azure/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
})
