{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, aiohttp
, diskcache
, gptcache
, msal
, nest-asyncio
, numpy
, openai
, platformdirs
, pygtrie
, pyparsing
, requests
, tiktoken
, torch
}:

buildPythonPackage rec {
  pname = "guidance";
  version = "0.0.64";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "guidance";
    rev = "refs/tags/${version}";
    hash = "sha256-tQpDJprxctKI88F+CZ9aSJbVo7tjmI4+VrI+WO4QlxE=";
  };

  propagatedBuildInputs = [
    aiohttp
    diskcache
    gptcache
    msal
    nest-asyncio
    numpy
    openai
    platformdirs
    pygtrie
    pyparsing
    requests
    tiktoken
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  disabledTests = [
    # require network access
    "test_each_parallel_with_gen_openai"
  ];

  disabledTestPaths = [
    # require network access
    "tests/library/test_gen.py"
    "tests/library/test_include.py"
    "tests/library/test_select.py"
    "tests/llms/test_openai.py"
    "tests/llms/test_transformers.py"
    "tests/test_program.py"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "guidance" ];

  meta = with lib; {
    description = "A guidance language for controlling large language models";
    homepage = "https://github.com/microsoft/guidance";
    changelog = "https://github.com/microsoft/guidance/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
