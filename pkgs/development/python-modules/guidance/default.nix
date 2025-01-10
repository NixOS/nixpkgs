{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pybind11,
  setuptools,
  wheel,
  aiohttp,
  azure-core,
  azure-identity,
  bitsandbytes,
  diskcache,
  fastapi,
  gptcache,
  jsonschema,
  msal,
  numpy,
  openai,
  ordered-set,
  pandas,
  papermill,
  platformdirs,
  protobuf,
  pyformlang,
  requests,
  tiktoken,
  transformers,
  torch,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.1.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    tag = version;
    hash = "sha256-dPakdT97cuLv4OwdaUFncopD5X6uXGyUjwzqn9fxnhU=";
  };

  nativeBuildInputs = [ pybind11 ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    diskcache
    fastapi
    gptcache
    msal
    numpy
    openai
    ordered-set
    platformdirs
    protobuf
    pyformlang
    requests
    tiktoken
    uvicorn
  ];

  nativeCheckInputs = [
    pytestCheckHook
    azure-core
    azure-identity
    bitsandbytes
    jsonschema
    pandas
    papermill
    torch
    transformers
  ];

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

    # flaky tests
    "test_remote_mock_gen" # frequently fails when building packages in parallel

    # requires "langchain_benchmarks"
    "test_retrieve_langchain_err"
  ];

  disabledTestPaths = [
    # require network access
    "tests/model_integration/"
    "tests/model_specific/"
    "tests/need_credentials/"
    "tests/notebooks/test_notebooks.py"
    "tests/server/test_server.py"
    "tests/unit/library/test_image.py"
    "tests/unit/test_tokenizers.py"
  ];

  preInstallCheck = ''
    export HF_HOME=$(mktemp -d)
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "guidance" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance";
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
