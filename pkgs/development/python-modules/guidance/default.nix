{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  diskcache,
  guidance-stitch,
  llguidance,
  numpy,
  ordered-set,
  platformdirs,
  psutil,
  pydantic,
  referencing,
  requests,
  tiktoken,

  # optional-dependencies
  openai,
  jsonschema,
  fastapi,
  uvicorn,

  # tests
  huggingface-hub,
  pytestCheckHook,
  tokenizers,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    tag = version;
    hash = "sha256-FBnND9kCIVmE/IEz3TNOww8x0EAH6TTBYfKTprqSbDg=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  pythonRelaxDeps = [
    "llguidance"
  ];

  dependencies = [
    diskcache
    guidance-stitch
    llguidance
    numpy
    ordered-set
    platformdirs
    psutil
    pydantic
    referencing
    requests
    tiktoken
  ];

  optional-dependencies = {
    azureai = [ openai ];
    openai = [ openai ];
    schemas = [ jsonschema ];
    server = [
      fastapi
      uvicorn
    ];
  };

  nativeCheckInputs = [
    huggingface-hub
    pytestCheckHook
    tokenizers
    torch
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.schemas;

  enabledTestPaths = [ "tests/unit" ];

  disabledTests = [
    # require network access
    "test_ll_backtrack_stop"
    "test_ll_dolphin"
    "test_ll_fighter"
    "test_ll_max_tokens"
    "test_ll_nice_man"
    "test_ll_nullable_bug"
    "test_ll_nullable_lexeme"
    "test_ll_pop_tokens"
    "test_ll_stop_quote_comma"
    "test_llparser"
    "test_str_method_smoke"

    # flaky tests
    "test_remote_mock_gen" # frequently fails when building packages in parallel
  ];

  preCheck = ''
    rm tests/conftest.py
  '';

  pythonImportsCheck = [ "guidance" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance";
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
