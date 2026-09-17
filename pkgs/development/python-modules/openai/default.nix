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
  inline-snapshot,
  pytest-asyncio,
  pytest-xdist,

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
    inline-snapshot
    pytest-asyncio
    pytest-xdist
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
