{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-groq,
  groq,
}:

buildPythonPackage rec {
  pname = "llm-groq";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angerman";
    repo = "llm-groq";
    tag = "v${version}";
    hash = "sha256-sZ5d9w43NvypaPrebwZ5BLgRaCHAhd7gBU6uHEdUaF4=";
  };

  build-system = [
    setuptools
    llm
  ];

  dependencies = [ groq ];

  pythonImportsCheck = [ "llm_groq" ];

  passthru.tests = llm.mkPluginTest llm-groq;

  meta = {
    description = "LLM plugin providing access to Groqcloud models.";
    homepage = "https://github.com/angerman/llm-groq";
    changelog = "https://github.com/angerman/llm-groq/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
