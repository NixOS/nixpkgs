{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pythonOlder,
  tweepy,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-twitter";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_twitter";
    inherit version;
    hash = "sha256-1bxg/tbv5NrMezm9OQUojiQGutv+yhWY4gkeUXb4z2o=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    llama-index-core
    tweepy
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.twitter" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for Twitter";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-twitter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
