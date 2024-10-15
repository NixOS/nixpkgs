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
  diskcache,
  fastapi,
  gptcache,
  msal,
  numpy,
  openai,
  ordered-set,
  platformdirs,
  protobuf,
  pyformlang,
  requests,
  tiktoken,
  torch,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.1.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    rev = "refs/tags/${version}";
    hash = "sha256-dvIJeSur3DdNBhrEPNPghxqmDEEig59Iz83LWksim6U=";
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
    torch
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
  ];

  disabledTestPaths = [
    # require network access
    "tests/library/test_gen.py"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "guidance" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance";
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
