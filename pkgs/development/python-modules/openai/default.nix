{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # native build inputs
  bash,

  # dependencies
  anyio,
  distro,
  httpx,
  jiter,
  pydantic,
  sniffio,
  tqdm,
  typing-extensions,

  # optional-dependencies (aiohttp)
  aiohttp,
  httpx-aiohttp,

  # optional-dependencies (bedock)
  botocore,

  # optional-dependencies (datalib)
  numpy,
  pandas,
  pandas-stubs,

  # optional-dependencies (httpx2)
  httpx2,

  # optional-dependencies (realtime)
  websockets,

  # optional-dependencies (voice-helpers)
  sounddevice,

  # check deps
  pytestCheckHook,
  dirty-equals,
  inline-snapshot,
  jsonschema,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  respx,

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
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7oFIiENP5d/TAVbkjtsjcsuin+qJ/tmjSdzXgu/qsCE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "hatchling==1.27.0" "hatchling"
    substituteInPlace tests/test_uv_workflows.py --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  nativeBuildInputs = [
    bash
  ];

  dependencies = [
    anyio
    distro
    httpx
    jiter
    pydantic
    sniffio
    tqdm
    typing-extensions
  ]
  ++ lib.optionals withAiohttp finalAttrs.passthru.optional-dependencies.aiohttp
  ++ lib.optionals withDatalib finalAttrs.passthru.optional-dependencies.datalib
  ++ lib.optionals withRealtime finalAttrs.passthru.optional-dependencies.realtime
  ++ lib.optionals withVoiceHelpers finalAttrs.passthru.optional-dependencies.voice-helpers;

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
    bedrock = [
      botocore
    ];
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
    httpx2 = [
      anyio
      httpx
      httpx2
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
    dirty-equals
    inline-snapshot
    jsonschema
    pytest-asyncio
    pytest-mock
    pytest-xdist
    respx
  ]
  # including pandas-stubs would cause infinite recursion
  ++ lib.concatAttrValues (lib.removeAttrs finalAttrs.passthru.optional-dependencies [ "datalib" ]);

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
    # E   TypeError: Unexpected type for 'content', <class 'inline_snapshot._external.external'>
    # This seems to be due to `inline-snapshot` being disabled when `pytest-xdist` is used.
    "tests/lib/chat/test_completions_streaming.py"

    # Tests the pypi build system (not relevant in Nix build environment)
    "tests/test_uv_workflows.py::test_explicit_root_build_keeps_every_public_dependency_source_build_disabled"
    "tests/test_uv_workflows.py::test_pydantic_v1_uses_separate_locked_environment"
    "tests/test_uv_workflows.py::test_build_uses_hashed_locked_build_group"
    "tests/test_uv_workflows.py::test_reviewed_root_build_still_runs_with_source_distribution_builds_disabled"

    # AssertionError
    "tests/test_uv_workflows.py::test_dependency_lock_source_check_accepts_the_committed_lock"

    # openai.APIConnectionError: Connection error (or RequestTined Out)
    "tests/lib/test_fine_tuning_positional_arguments.py::TestCheckpoints::test_method_list"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestCheckpoints::test_method_list_with_all_params"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestCheckpoints::test_raw_response_list"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestCheckpoints::test_streaming_response_list"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncCheckpoints::test_method_list"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncCheckpoints::test_method_list_with_all_params"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncCheckpoints::test_raw_response_list"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncCheckpoints::test_streaming_response_list"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestJobs::test_method_list_events"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestJobs::test_method_list_events_with_all_params"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestJobs::test_raw_response_list_events"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestJobs::test_streaming_response_list_events"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncJobs::test_method_list_events"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncJobs::test_method_list_events_with_all_params"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncJobs::test_raw_response_list_events"
    "tests/lib/test_fine_tuning_positional_arguments.py::TestAsyncJobs::test_streaming_response_list_events"
    "tests/test_tls_hostname.py::test_async_tls_verifies_configured_hostname"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Operation not permitted (in sandbox)
    "test_pydantic_v1_uses_separate_locked_environment"
    "test_build_uses_hashed_locked_build_group"
    "test_reviewed_root_build_still_runs_with_source_distribution_builds_disabled"
    "test_explicit_root_build_keeps_every_public_dependency_source_build_disabled"
    "test_sync_tls_verifies_configured_hostname"
    "test_async_tls_verifies_configured_hostname"
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
