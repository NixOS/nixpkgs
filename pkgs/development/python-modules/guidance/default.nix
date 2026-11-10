{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  guidance-stitch,
  jinja2,
  llguidance,
  numpy,
  psutil,
  pydantic,
  requests,

  # optional-dependencies
  openai,

  # tests
  huggingface-hub,
  jsonschema,
  pytestCheckHook,
  tokenizers,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "guidance";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    tag = finalAttrs.version;
    hash = "sha256-g0Vb5qcEvGY4S/LzhQvYtLiN1gIDBhPIgdzenSYX7zQ=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  pythonRelaxDeps = [
    "llguidance"
  ];

  dependencies = [
    guidance-stitch
    jinja2
    llguidance
    numpy
    psutil
    pydantic
    requests
  ];

  optional-dependencies = {
    azureai = [
      # azure-ai-inference
      openai
    ];
    openai = [ openai ];
  };

  nativeCheckInputs = [
    huggingface-hub
    jsonschema
    pytestCheckHook
    tokenizers
    torch
    writableTmpDirAsHomeHook
  ];

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
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
