{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  httpx,
  llama-cpp-python,
  llm,
}:

buildPythonPackage rec {
  pname = "llm-gguf";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gguf";
    tag = version;
    hash = "sha256-ihMOiQnTfgZKICVDoQHLOMahrd+GiB+HwWFBMyIcs0A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx
    llama-cpp-python
    llm
  ];

  pythonImportsCheck = [ "llm_gguf" ];

  # Tests require internet access (downloading models)
  doCheck = false;

  meta = {
    description = "Run models distributed as GGUF files using LLM";
    homepage = "https://github.com/simonw/llm-gguf";
    changelog = "https://github.com/simonw/llm-gguf/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
