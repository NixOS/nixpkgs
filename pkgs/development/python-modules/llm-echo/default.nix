{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-echo,
  pytest-asyncio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-echo";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-echo";
    tag = version;
    hash = "sha256-E0C/SZ+0t1iPWulr/xaQQPzRR7Qg7nF/X5/HX8QxkMw=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: assert [ToolCall(nam...406gay3qev4')] == [ToolCall(nam...ca...
    # (output differs due to version changes)
    "test_prompt_with_tool_calls"
  ];

  pythonImportsCheck = [ "llm_echo" ];

  passthru.tests = llm.mkPluginTest llm-echo;

  meta = {
    description = "Debug plugin for LLM";
    homepage = "https://github.com/simonw/llm-echo";
    changelog = "https://github.com/simonw/llm-echo/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
