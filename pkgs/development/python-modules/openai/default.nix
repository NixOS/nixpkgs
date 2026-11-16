{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # native build inputs
  bash,

  # dependencies
  anyio,
  httpx2,
  jiter,
  pydantic,
  sniffio,
  typing-extensions,

  # optional-dependencies
  aiohttp,
  botocore,
  numpy,
  pandas,
  sounddevice,
  urllib3,
  websockets,

  # check deps
  pytestCheckHook,
  griffe,
  inline-snapshot,
  pytest-asyncio,
  pytest-xdist,
  trio,

  # optional-dependencies toggle
  withAiohttp ? false,
  withDatalib ? false,
  withRealtime ? false,
  withVoiceHelpers ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai";
  version = "3.51.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Er1kq3JcjHBNHtaOcSbDfOT5Eb6eqRxL5l68pgQCq4k=";
  };

  postPatch = ''
    sed -i -E 's/hatchling[><=!~]+[0-9a-zA-Z.*,-]+/hatchling/g' pyproject.toml
    substituteInPlace tests/test_uv_workflows.py --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    bash
  ];

  dependencies = [
    anyio
    httpx2
    jiter
    pydantic
    sniffio
    typing-extensions
  ]
  ++ lib.optionals withAiohttp finalAttrs.passthru.optional-dependencies.aiohttp
  ++ lib.optionals withDatalib finalAttrs.passthru.optional-dependencies.datalib
  ++ lib.optionals withRealtime finalAttrs.passthru.optional-dependencies.realtime
  ++ lib.optionals withVoiceHelpers finalAttrs.passthru.optional-dependencies.voice-helpers;

  optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    bedrock = [
      botocore
      urllib3
    ];
    datalib = [
      numpy
      pandas
    ];
    realtime = [
      websockets
    ];
    voice-helpers = [
      numpy
      sounddevice
    ];
  };

  pythonImportsCheck = [ "openai" ];

  nativeCheckInputs = [
    pytestCheckHook
    griffe
    inline-snapshot
    pytest-asyncio
    pytest-xdist
    trio
  ]
  # including pandas-stubs would cause infinite recursion
  ++ lib.concatAttrValues (lib.removeAttrs finalAttrs.passthru.optional-dependencies [ "datalib" ]);

  disabledTestPaths = [
    # tests makes network requests
    "tests/api_resources"
    "tests/lib/test_fine_tuning_positional_arguments.py"
    "tests/test_tls_hostname.py"

    # Tests the pypi build system (not relevant in Nix build environment)
    "tests/test_uv_workflows.py"

    # flaky
    "tests/lib/test_azure_redirects.py::test_sync_redirect_origin"

    # FileNotFoundError: [Errno 2] No such file or directory: 'git'
    "tests/test_consumer_compatibility.py::test_compatibility_gate_selects_callers"

    # FileNotFoundError: [Errno 2] No such file or directory: 'ps'
    "tests/test_example_security.py"

    # TimeoutError
    "tests/lib/test_realtime_example_keepalive.py"

    # Unhandled thread exception
    "tests/lib/test_beta_realtime_auth_policy.py"

    # Fails to load typing_extensions even when it's in nativeCheckInputs
    "tests/test_lazy_imports.py"
  ];

  meta = {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      malo
      sarahec
    ];
  };
})
