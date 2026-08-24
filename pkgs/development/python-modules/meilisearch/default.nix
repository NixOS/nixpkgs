{
  lib,
  buildPythonPackage,
  camel-converter,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "meilisearch";
  version = "0.43.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MacgsQTBajb7bjzxnhc4naxncW/3XAI0EWniLf9KeJI=";
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

  meta = {
    description = "Client for the Meilisearch API";
    homepage = "https://github.com/meilisearch/meilisearch-python";
    changelog = "https://github.com/meilisearch/meilisearch-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
