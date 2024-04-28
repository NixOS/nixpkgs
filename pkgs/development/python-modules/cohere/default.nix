{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
, fastavro
, httpx
, httpx-sse
, pydantic
, requests
, tokenizers
, types-requests
, typing-extensions
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "5.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+/WcC6sN7U0oCR+gwZOhFtgwPEwLCaQnId2KEjDqJ8M=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    fastavro
    httpx
    httpx-sse
    pydantic
    requests
    tokenizers
    types-requests
    typing-extensions
  ];

  # tests require CO_API_KEY
  doCheck = false;

  pythonImportsCheck = [
    "cohere"
  ];

  meta = with lib; {
    description = "Simplify interfacing with the Cohere API";
    homepage = "https://docs.cohere.com/docs";
    changelog = "https://github.com/cohere-ai/cohere-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
