{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  groq,

  # tests
  langchain-tests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-groq";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-groq==${version}";
    hash = "sha256-TXmAaEOK2qNglNAa02M027NXmocsxFaQi3tUFdmFQUQ=";
  };

  sourceRoot = "${src.name}/libs/partners/groq";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [ "langchain-core" ];

  dependencies = [
    langchain-core
    groq
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_groq" ];

  passthru = {
    inherit (langchain-core) updateScript;
    skipBulkUpdate = true; # Broken, see https://github.com/NixOS/nixpkgs/issues/379898
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-groq==${version}";
    description = "Integration package connecting Groq and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/groq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
}
