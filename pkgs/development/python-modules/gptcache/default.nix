{ lib
, buildPythonPackage
, fetchFromGitHub
, cachetools
, numpy
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "gptcache";
  version = "0.1.37";
  format = "setuptools";

  disabled = pythonOlder "3.8.1";

  src = fetchFromGitHub {
    owner = "zilliztech";
    repo = "GPTCache";
    rev = "refs/tags/${version}";
    hash = "sha256-eQu3O6jPL1BRObA99XA2EOznn9NaArVRouqD1Ypz/4w=";
  };

  propagatedBuildInputs = [
    cachetools
    numpy
    requests
  ];

  # many tests require network access and complicated dependencies
  doCheck = false;

  pythonImportsCheck = [ "gptcache" ];

  meta = with lib; {
    description = "Semantic cache for LLMs and fully integrated with LangChain and llama_index";
    homepage = "https://github.com/zilliztech/GPTCache";
    changelog = "https://github.com/zilliztech/GPTCache/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
