{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
  tweepy,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-twitter";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_twitter";
    inherit version;
    hash = "sha256-WguqvAbb6xbuTZDL55Qyv35DdJ7DjqrnvtyxMYe9Tkc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    tweepy
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.twitter" ];

  meta = {
    description = "LlamaIndex Readers Integration for Twitter";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-twitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
