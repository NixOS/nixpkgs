{
  lib,
  aws-lc,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  zstd,

  # optional-dependencies
  # langchain:
  langchain,
  langchain-anthropic,
  langchain-core,
  langgraph,
  langgraph-checkpoint,
  langgraph-sdk,
  langsmith,
  pydantic,
  # deepagents:
  cryptography,
  pyasn1,
  # langchain-nvidia:
  aiohttp,
  idna,
  multidict,
  # google-adk:
  typing-extensions,

  # tests
  cacert,
  grpcio,
  opentelemetry-proto,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nemo-relay";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nemo-relay";
    tag = finalAttrs.version;
    hash = "sha256-BwoeCwHbvVNtx4fkR1uIRh95T63UBMbvrJtiE6+/BWY=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail '"0.11.0"' '"${finalAttrs.version}"'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-xjImAQmLLOzSuO0LMRnoIZ5SoYMv7WBFSkJxgL+AOX4=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  optional-dependencies = {
    cli = [
      # no-op, placeholder for platform specific wheels
    ];
    langchain = [
      langchain
      langchain-anthropic
      langchain-core
      langgraph
      langgraph-checkpoint
      langgraph-sdk
      langsmith
      pydantic
    ];
    langgraph = [
      langgraph
    ]
    ++ finalAttrs.passthru.optional-dependencies.langchain;
    deepagents = [
      cryptography
      # deepagents # not packaged
      langchain-anthropic
      pyasn1
    ]
    ++ finalAttrs.passthru.optional-dependencies.langgraph;
    langchain-nvidia = [
      aiohttp
      idna
      # langchain-nvidia-ai-endpoints # not packaged
      multidict
    ]
    ++ finalAttrs.passthru.optional-dependencies.langchain;
    google-adk = [
      # google-adk # not packaged
      typing-extensions
    ];
  };

  preCheck = ''
    rm -r python/nemo_relay
  '';

  nativeCheckInputs = [
    grpcio
    opentelemetry-proto
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.langchain;

  disabledTestPaths = [
    # wants to call uv
    "python/tests/plugin/test_package_build.py::test_sdist_rebuilds_worker_bindings_without_checked_in_codegen"
    # wants to call cargo
    "python/tests/test_dynamic_plugin_host.py::test_worker_activation_executes_and_releases_callbacks"
    "python/tests/test_dynamic_plugin_host.py::test_worker_activation_finalizer_never_waits_on_python_thread"
    # nemo_relay_plugin is not packaged
    "python/tests/plugin/"
    # re-execs python without PYTHONPATH
    "python/tests/test_observability_type_contracts.py"
    "python/tests/test_public_type_contracts.py"
    # requires some test fixtures to be set up
    "python/tests/test_dynamic_plugin_host.py"
    # failed to build the OTLP exporter: tls.certificate/client_certificate/private_key: invalid TLS trust or client identity
    "python/tests/test_observability_plugin.py"
    "python/tests/test_types.py"
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
