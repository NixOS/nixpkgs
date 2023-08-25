{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
, aiohttp
, backoff
, fastavro
, importlib-metadata
, requests
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "4.21";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9hFDj0Cd/F1aChU6WFNJ9agLFpxxArWZTZmZ7PhECGY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    fastavro
    importlib-metadata
    requests
  ];

  # tests require CO_API_KEY
  doCheck = false;

  pythonImportsCheck = [
    "cohere"
  ];

  meta = with lib; {
    description = "Simplify interfacing with the Cohere API";
    homepage = "https://docs.cohere.com/docs";
    changelog = "https://github.com/cohere-ai/cohere-python/blob/main/CHANGELOG.md#${builtins.replaceStrings ["."] [""] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
