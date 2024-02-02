{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
, aiohttp
, dataclasses-json
, langchain-core
, langsmith
, numpy
, pyyaml
, requests
, sqlalchemy
, tenacity
, typer
}:

buildPythonPackage rec {
  pname = "langchain-community";
  version = "0.0.17";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "langchain_community";
    inherit version;
    hash = "sha256-q5V7NKVi4BmbLs8FC9yYfE/oibKsnyK3Wp+si54w9To=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
    cli = [
      typer
    ];
  };

  pythonImportsCheck = [ "langchain_community" ];

  # PyPI source does not have tests
  doCheck = false;

  meta = with lib; {
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/community";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
