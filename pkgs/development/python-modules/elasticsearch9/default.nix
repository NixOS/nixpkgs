{
  lib,
  aiohttp,
  anyio,
  buildPythonPackage,
  elastic-transport_9,
  fetchPypi,
  hatchling,
  orjson,
  python-dateutil,
  requests,
  sniffio,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "elasticsearch9";
  version = "9.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-WPj2PfqPLHXm2HVM6avl0noLL+35OHNW0z9zaKMvAXo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    elastic-transport_9
    python-dateutil
    sniffio
    typing-extensions
  ];

  optional-dependencies = {
    async = [ aiohttp ];
    requests = [ requests ];
    orjson = [ orjson ];
  };

  doCheck = false;

  pythonImportsCheck = [ "elasticsearch9" ];

  meta = {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elastic/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
