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
<<<<<<< HEAD
  version = "8.19.3";
=======
  version = "8.19.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-fv/pWzYCQbbVbvaCGQN6kK0PVnI2FNtUu+V9MwWEAvQ=";
=======
    hash = "sha256-lDfI5RI8JgtZdmGDv9kVIGdyVChJtpf3inlEbsiQqA4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
