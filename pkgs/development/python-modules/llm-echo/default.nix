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
  version = "0.3a3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-echo";
    tag = version;
    hash = "sha256-4345UIyaQx+mYYBAFD5AaX5YbjbnJQt8bKMD5Vl8VJc=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
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
