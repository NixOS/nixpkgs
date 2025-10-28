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
  version = "8.19.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lDfI5RI8JgtZdmGDv9kVIGdyVChJtpf3inlEbsiQqA4=";
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

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
