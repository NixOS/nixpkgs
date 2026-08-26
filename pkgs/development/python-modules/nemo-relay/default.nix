{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # optional-dependencies
  # langchain:
  langchain,
  langchain-core,
  langgraph,
  langgraph-checkpoint,
  langsmith,
  # deepagents:
  langchain-anthropic,
  # langchain-nvidia:
  aiohttp,

  # tests
  cacert,
  opentelemetry-proto,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nemo-relay";
  version = "0.7.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nemo-relay";
    tag = finalAttrs.version;
    hash = "sha256-g7xHQOcccuyHIBiVY5GQHpd1vk99RMwuw923OR4+x3E=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail '"0.7.0"' '"${finalAttrs.version}"'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-Re/R/0aSxFNNG9jnbSg+3D0OhQV1mPyxmIJT7ExFaP0=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  optional-dependencies = {
    cli = [
      # no-op, placeholder for platform specific wheels
    ];
    langchain = [
      langchain
      langchain-core
      langgraph
      langgraph-checkpoint
      langsmith
    ];
    langgraph = [
      langgraph
    ]
    ++ finalAttrs.passthru.optional-dependencies.langchain;
    deepagents = [
      # deepagents # not packaged
      langchain-anthropic
    ]
    ++ finalAttrs.passthru.optional-dependencies.langgraph;
    langchain-nvidia = [
      # langchain-nvidia-ai-endpoints # not packaged
      aiohttp
    ]
    ++ finalAttrs.passthru.optional-dependencies.langchain;
  };

  preCheck = ''
    rm -r python/nemo_relay
  '';

  nativeCheckInputs = [
    cacert
    opentelemetry-proto
    pydantic
    pytest-asyncio
    pytestCheckHook
    typing-extensions
  ]
  ++ finalAttrs.passthru.optional-dependencies.langchain;

  disabledTestPaths = [
    # wants to call uv
    "python/tests/plugin/test_package_build.py::test_sdist_rebuilds_worker_bindings_without_checked_in_codegen"
    # wants to call cargo
    "python/tests/test_dynamic_plugin_host.py::test_worker_activation_executes_and_releases_callbacks"
    "python/tests/test_dynamic_plugin_host.py::test_worker_activation_finalizer_never_waits_on_python_thread"
  ];

  pythonImportsCheck = [
    "nemo_relay"
    "nemo_relay._native"
    # taken from https://github.com/NVIDIA/NeMo-Relay/tree/main/python/nemo_relay#package-surface
    "nemo_relay.adaptive"
    "nemo_relay.codecs"
    "nemo_relay.guardrails"
    "nemo_relay.intercepts"
    "nemo_relay.llm"
    "nemo_relay.observability"
    "nemo_relay.plugin"
    "nemo_relay.scope"
    "nemo_relay.subscribers"
    "nemo_relay.tools"
    "nemo_relay.typed"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python bindings for the NeMo Relay agent runtime";
    homepage = "https://github.com/NVIDIA/NeMo-Relay";
    changelog = "https://github.com/NVIDIA/NeMo-Relay/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    teams = [ lib.teams.cuda ];
    license = lib.licenses.asl20;
  };
})
