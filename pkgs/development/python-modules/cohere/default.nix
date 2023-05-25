{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
, requests
, aiohttp
, backoff
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "4.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+/oeZpYyCrQava0lEt5uLlSc65XaBCyI/G/lwAxfBTA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    aiohttp
    backoff
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
