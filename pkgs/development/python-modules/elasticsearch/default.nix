{
  lib,
  aiohttp,
  buildPythonPackage,
  elastic-transport,
  fetchPypi,
  hatchling,
  orjson,
  pyarrow,
  python-dateutil,
  pythonOlder,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "elasticsearch";
  version = "8.18.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mYA18XqMH7p64msYPcp5fc+V24baan7LpW0xr8QPB8c=";
  };

  build-system = [ hatchling ];

  dependencies = [
    elastic-transport
    python-dateutil
    typing-extensions
  ];

  optional-dependencies = {
    requests = [ requests ];
    async = [ aiohttp ];
    orjson = [ orjson ];
    pyarrow = [ pyarrow ];
  };

  pythonImportsCheck = [ "elasticsearch" ];

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
  };
}
