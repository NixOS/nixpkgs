{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  langchain-core,
  lxml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "langchain_text_splitters";
    inherit version;
    hash = "sha256-rIkn3AugjrpwL2lhye19986tjeGan3EBqyteo0IBs8E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    lxml
  ];

  # PyPI source does not have tests
  doCheck = false;

  pythonImportsCheck = [ "langchain_text_splitters" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = with lib; {
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
