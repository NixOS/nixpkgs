{
  lib,
  buildPythonPackage,
  camel-converter,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "meilisearch";
  version = "0.36.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch-python";
    tag = "v${version}";
    hash = "sha256-S6l/nH+UWLgNUOkRVjLptKhWeYrlN1KL8jSfyBHMI3s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    camel-converter
    requests
  ]
  ++ camel-converter.optional-dependencies.pydantic;

  pythonImportsCheck = [ "meilisearch" ];

  # Tests spin up a local server and are not mocking the requests
  doCheck = false;

  meta = with lib; {
    description = "Client for the Meilisearch API";
    homepage = "https://github.com/meilisearch/meilisearch-python";
    changelog = "https://github.com/meilisearch/meilisearch-python/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
