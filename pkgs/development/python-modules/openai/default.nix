{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  hatchling,

  # dependencies
  anyio,
  httpx,
  httpx2,
  jiter,
  pydantic,
  sniffio,
  typing-extensions,

  # optional-dependencies (aiohttp)
  aiohttp,

  # optional-dependencies (bedrock)
  botocore,
  urllib3,

  # optional-dependencies (datalib)
  numpy,
  pandas,

  # optional-dependencies (realtime)
  websockets,

  # optional-dependencies (voice-helpers)
  sounddevice,

  # check deps
  pytestCheckHook,
  inline-snapshot,
  pytest-asyncio,
  pytest-xdist,
  rich,

  # optional-dependencies toggle
  withAiohttp ? false,
  withDatalib ? false,
  withRealtime ? false,
  withVoiceHelpers ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai";
  version = "3.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7oFIiENP5d/TAVbkjtsjcsuin+qJ/tmjSdzXgu/qsCE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "hatchling==1.27.0" "hatchling"
    # tests/test_uv_workflows.py invokes /bin/bash directly
    substituteInPlace tests/test_uv_workflows.py \
      --replace-fail '"/bin/bash"' "\"${lib.getExe bash}\""
  '';

  # scripts/build and scripts/test-pydantic-v1 are executed by tests/test_uv_workflows.py
  preCheck = ''
    patchShebangs scripts
  '';

  build-system = [
    hatchling
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
    inline-snapshot
    pytest-asyncio
    pytest-xdist
    rich
    httpx
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
    # Requires the Prism mock server
    "tests/lib/test_fine_tuning_positional_arguments.py"
    # E   TypeError: Unexpected type for 'content', <class 'inline_snapshot._external.external'>
    # This seems to be due to `inline-snapshot` being disabled when `pytest-xdist` is used.
    "tests/lib/chat/test_completions_streaming.py"
  ];

  disabledTests = [
    # Starts a local TLS server
    "test_async_tls_verifies_configured_hostname[aiohttp"
    # Runs upstream's CI dependency-provenance check against the uv lock file
    "test_dependency_lock_source_check_accepts_the_committed_lock"
    # Flaky: unraisable exception warnings from the TLS mock server
    "test_async_request_preserves_tls_hostname"
    "test_sync_request_preserves_tls_hostname"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
  };
})
