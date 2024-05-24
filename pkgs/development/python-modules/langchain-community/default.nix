{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
  aiohttp,
  dataclasses-json,
  langchain-core,
  langsmith,
  numpy,
  pyyaml,
  requests,
  sqlalchemy,
  tenacity,
  typer,
}:

buildPythonPackage rec {
  pname = "langchain-community";
  version = "0.0.38";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "langchain_community";
    inherit version;
    hash = "sha256-En/Et1vGe2L+gnxmwC5xWnMP74/mm9ICPUZrqwa1gQ0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    dataclasses-json
    langchain-core
    langsmith
    numpy
    pyyaml
    requests
    sqlalchemy
    tenacity
  ];

  passthru.optional-dependencies = {
    cli = [ typer ];
  };

  pythonImportsCheck = [ "langchain_community" ];

  # PyPI source does not have tests
  doCheck = false;

  passthru = {
    updateScript = langchain-core.updateScript;
  };

  meta = with lib; {
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/community";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
