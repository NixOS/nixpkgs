{
  lib,
  buildPythonPackage,
  elasticsearch,
  fetchPypi,
  python-dateutil,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "elasticsearch-dsl";
  version = "8.16.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "elasticsearch_dsl";
    inherit version;
    hash = "sha256-Bb1QUO730HBqRIfNIoZNPBWMjhy8omtT7xpHO97hNFk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    elasticsearch
    python-dateutil
    typing-extensions
  ];

  optional-dependencies = {
    async = [ elasticsearch ] ++ elasticsearch.optional-dependencies.async;
  };

  # ImportError: No module named test_elasticsearch_dsl
  # Tests require a local instance of elasticsearch
  doCheck = false;

  meta = with lib; {
    description = "High level Python client for Elasticsearch";
    longDescription = ''
      Elasticsearch DSL is a high-level library whose aim is to help with
      writing and running queries against Elasticsearch. It is built on top of
      the official low-level client (elasticsearch-py).
    '';
    homepage = "https://github.com/elasticsearch/elasticsearch-dsl-py";
    changelog = "https://github.com/elastic/elasticsearch-dsl-py/blob/v${version}/Changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
