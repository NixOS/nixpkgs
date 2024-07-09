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
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-/BUn/NxaE9l3VY6dPshr1JJaHTGzn9NMQhSQ2De65Jg=";
  };

  sourceRoot = "${src.name}/libs/partners/chroma";

  build-system = [ poetry-core ];

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
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
