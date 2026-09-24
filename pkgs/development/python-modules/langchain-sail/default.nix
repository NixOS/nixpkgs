{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  langchain-community,
  langchain-classic,

  # tests
  pytestCheckHook,
  pytest-asyncio,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-sail";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lakehq";
    repo = "langchain-sail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-geXv2vzvRyjVyslTam1yIkRsgmyTr5A84BIVsqXODes=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    langchain-core
    langchain-community
    langchain-classic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # The integration tests need pyspark-client (not packaged) and a running Sail
  # server, so only the unit tests can run in the sandbox.
  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_sail" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LangChain integration for Sail, a Spark-compatible compute engine on Apache Arrow and DataFusion";
    homepage = "https://github.com/lakehq/langchain-sail";
    changelog = "https://github.com/lakehq/langchain-sail/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.davidlghellin ];
  };
})
