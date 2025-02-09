{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pybind11
, setuptools
, wheel
, aiohttp
, diskcache
, gptcache
, msal
, nest-asyncio
, numpy
, openai
, ordered-set
, platformdirs
, pyformlang
, requests
, tiktoken
, torch
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "guidance-ai";
    repo = "guidance";
    rev = "refs/tags/${version}";
    hash = "sha256-Z3EuHAQPPXf/i0HnbDhGv5KBUBP0aZDHTwpff7g2E3g=";
  };

  nativeBuildInputs = [
    pybind11
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    diskcache
    gptcache
    msal
    nest-asyncio
    numpy
    openai
    ordered-set
    platformdirs
    pyformlang
    requests
    tiktoken
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
  ];

  disabledTestPaths = [
    # require network access
    "tests/library/test_gen.py"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "guidance" ];

  meta = with lib; {
    description = "A guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance";
    changelog = "https://github.com/guidance-ai/guidance/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
