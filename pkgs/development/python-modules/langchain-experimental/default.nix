{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  langchain-community,
}:

buildPythonPackage rec {
  pname = "langchain-experimental";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-experimental";
    rev = "refs/tags/libs/experimental/v${version}";
    hash = "sha256-TgtLphKmFJxIh2z+Sn513G/d9dnq65HNsMoluqpd3VE=";
  };

  sourceRoot = "${src.name}/libs/experimental";

  dependencies = [
    langchain-core
    langchain-community
  ];

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "langchain_experimental" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    description = "This package holds experimental LangChain code, intended for research and experimental uses.";
    downloadPage = "https://github.com/langchain-ai/langchain-experimental/releases/tag/libs%2Fexperimental%2Fv${version}";
    homepage = "https://pypi.org/project/langchain-experimental/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
