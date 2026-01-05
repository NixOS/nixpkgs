{
  lib,
  aiohttp,
  buildPythonPackage,
  elastic-transport,
  fetchPypi,
  hatchling,
  orjson,
  python-dateutil,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "elasticsearch8";
  version = "8.19.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fv/pWzYCQbbVbvaCGQN6kK0PVnI2FNtUu+V9MwWEAvQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    elastic-transport
    python-dateutil
    typing-extensions
  ];

  optional-dependencies = {
    async = [ aiohttp ];
    requests = [ requests ];
    orjson = [ orjson ];
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/main/test_elasticsearch
  doCheck = false;

  pythonImportsCheck = [ "elasticsearch8" ];

  meta = {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
