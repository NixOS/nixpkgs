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
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "langchain_community";
    inherit version;
    hash = "sha256-z2bG/3/L61gvXojuAN7Op/3spczd2nJQRvKO/Gl8Qac=";
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
