{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  cohere,
  pandas,
  tabulate,
  langchain-experimental,
  langchain-community,
  pydantic,
}:

buildPythonPackage rec {
  pname = "langchain-cohere";
  version = "0.3.1";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-cohere";
    rev = "refs/tags/libs/cohere/v${version}";
    hash = "sha256-4334m64pWYPSkfaRCZJGmkMM7UlKoSU+JDi30kpN/Y8=";
  };

  sourceRoot = "${src.name}/libs/cohere";

  dependencies = [
    langchain-core
    cohere
    pandas
    tabulate
    langchain-experimental
    langchain-community
    pydantic
  ];

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "langchain_cohere" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    description = "Cohere integrations with LangChain";
    downloadPage = "https://github.com/langchain-ai/langchain-cohere/releases/tag/libs%2Fcohere%2Fv${version}";
    homepage = "https://pypi.org/project/langchain-cohere/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
