{
  lib,
  aiohttp,
  buildPythonPackage,
  elastic-transport,
  fetchPypi,
  orjson,
  pythonOlder,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "elasticsearch8";
  version = "8.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JiiJSjdWAocHvQ9RCGTUJD05hoSE23LYxvzMlELJUfM=";
  };

  build-system = [ setuptools ];

  dependencies = [ elastic-transport ];

  passthru.optional-dependencies = {
    async = [ aiohttp ];
    requests = [ requests ];
    orjson = [ orjson ];
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/main/test_elasticsearch
  doCheck = false;

  pythonImportsCheck = [ "elasticsearch8" ];

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
