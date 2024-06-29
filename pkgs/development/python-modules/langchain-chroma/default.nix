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
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-chroma==${version}";
    hash = "sha256-PW4vfZVccuYnaR0jtOfHVaXXYoUyQbCfB8NwM+mXFGc=";
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
