{
  lib,
  buildPythonPackage,
  camel-converter,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "meilisearch";
  version = "0.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch-python";
    tag = "v${version}";
    hash = "sha256-KTWeBjNQDZEla2iDfsW5cuGfjoV0c2MV8HrOxg0hs4E=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
