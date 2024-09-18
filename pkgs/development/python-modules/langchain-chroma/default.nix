{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chromadb,
  langchain-core,
  numpy,
  poetry-core,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langchain-chroma";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-chroma==${version}";
    hash = "sha256-pU7H8OYXa+JjdkSO36xESPI6r3xA+9cFXxeJnfpYuHc=";
  };

  sourceRoot = "${src.name}/libs/partners/chroma";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "chromadb" ];

  dependencies = [
    langchain-core
    chromadb
    numpy
  ];

  pythonImportsCheck = [ "langchain_chroma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-chroma==(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-chroma==${version}";
    description = "Integration package connecting Chroma and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/chroma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
