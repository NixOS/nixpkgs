{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cachetools,
  numpy,
  pythonOlder,
  redis,
  redis-om,
  requests,
}:

buildPythonPackage rec {
  pname = "gptcache";
  version = "0.1.44";
  format = "setuptools";

  disabled = pythonOlder "3.8.1";

  src = fetchFromGitHub {
    owner = "zilliztech";
    repo = "GPTCache";
    rev = "refs/tags/${version}";
    hash = "sha256-FRqngDyGO0ReTRtm9617TFLHVXWY9/NQlZHlBP8ukg0=";
  };

  propagatedBuildInputs = [
    cachetools
    numpy
    redis
    redis-om
    requests
  ];

  # many tests require network access and complicated dependencies
  doCheck = false;

  pythonImportsCheck = [ "gptcache" ];

  meta = with lib; {
    description = "Semantic cache for LLMs and fully integrated with LangChain and llama_index";
    mainProgram = "gptcache_server";
    homepage = "https://github.com/zilliztech/GPTCache";
    changelog = "https://github.com/zilliztech/GPTCache/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
