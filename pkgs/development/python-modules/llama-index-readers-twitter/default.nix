{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
, tweepy
}:

buildPythonPackage rec {
  pname = "llama-index-readers-twitter";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_twitter";
    inherit version;
    hash = "sha256-ZPwluiPdSkwMZ3JQy/HHhR7erYhUE9BWtplkfHk+TK8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
    tweepy
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.readers.twitter"
  ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for Twitter";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-twitter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
