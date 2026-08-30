{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-github-copilot,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  pytest-vcr,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "llm-github-copilot";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmdaly";
    repo = "llm-github-copilot";
    tag = version;
    hash = "sha256-BUVpt1Vv0+kxbTYHDdiYy3+ySJKWJ9b+dYexV7YS+NI=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    pytest-vcr
    pytest-asyncio
  ];

  pythonImportsCheck = [ "llm_github_copilot" ];

  passthru.tests = llm.mkPluginTest llm-github-copilot;

  meta = {
    description = "LLM plugin providing access to GitHub Copilot";
    homepage = "https://github.com/jmdaly/llm-github-copilot";
    changelog = "https://github.com/jmdaly/llm-github-copilot/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ afh ];
  };
}
