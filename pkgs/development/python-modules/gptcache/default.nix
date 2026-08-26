{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cachetools,
  numpy,
  redis,
  redis-om,
  requests,
}:

buildPythonPackage rec {
  pname = "gptcache";
  version = "0.1.44";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zilliztech";
    repo = "GPTCache";
    tag = version;
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

  meta = {
    description = "Semantic cache for LLMs and fully integrated with LangChain and llama_index";
    mainProgram = "gptcache_server";
    homepage = "https://github.com/zilliztech/GPTCache";
    changelog = "https://github.com/zilliztech/GPTCache/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
