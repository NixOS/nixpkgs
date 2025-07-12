{
  lib,
  aiohttp,
  buildPythonPackage,
  elastic-transport,
  fetchPypi,
  hatchling,
  orjson,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "elasticsearch8";
  version = "8.17.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j6FaQWPFJ8kqoTwjIPyMDcOZBg8mOO0BbKCFn4ESCAM=";
  };

  build-system = [ hatchling ];

  dependencies = [ elastic-transport ];

  optional-dependencies = {
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
