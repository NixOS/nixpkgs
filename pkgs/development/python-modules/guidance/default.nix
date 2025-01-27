{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pybind11,
  setuptools,
  diskcache,
  fastapi,
  huggingface-hub,
  jsonschema,
  numpy,
  openai,
  ordered-set,
  platformdirs,
  protobuf,
  pydantic,
  requests,
  tiktoken,
  torch,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    tag = version;
    hash = "sha256-dZfz/P4+dTHdGFhLAdwX0D/QRdojqNy8+UCbFk0QeTM=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  dependencies = [
    diskcache
    numpy
    ordered-set
    platformdirs
    protobuf
    pydantic
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
    torch
  ] ++ optional-dependencies.schemas;

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # require network access
    "test_select_simple"
    "test_commit_point"
    "test_token_healing"
    "test_fstring"
    "test_fstring_custom"
    "test_token_count"
    "test_gpt2"
    "test_recursion_error"
    "test_openai_class_detection"
    "test_openai_chat_without_roles"
    "test_local_image"
    "test_remote_image"
    "test_image_from_bytes"
    "test_remote_image_not_found"

    # flaky tests
    "test_remote_mock_gen" # frequently fails when building packages in parallel
  ];

  disabledTestPaths = [
    # require network access
    "tests/unit/test_tokenizers.py"
  ];

  preCheck = ''
    export HOME=$TMPDIR
    rm tests/conftest.py
  '';

  pythonImportsCheck = [ "guidance" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance";
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
