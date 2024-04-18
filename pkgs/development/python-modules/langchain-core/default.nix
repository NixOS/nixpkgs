{
  lib,
  anyio,
  buildPythonPackage,
  fetchPypi,
  jsonpatch,
  langsmith,
  packaging,
  poetry-core,
  pydantic,
  pythonOlder,
  pythonRelaxDepsHook,
  pyyaml,
  requests,
  tenacity,
}:

buildPythonPackage rec {
  pname = "langchain-core";
  version = "0.1.44";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "langchain_core";
    inherit version;
    hash = "sha256-4xOXXZrikmNC5vKtdgM40x8YsSI+m4tNxAja7q3kaoM=";
  };

  pythonRelaxDeps = [
    "langsmith"
    "packaging"
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    anyio
    jsonpatch
    langsmith
    packaging
    pydantic
    pyyaml
    requests
    tenacity
  ];

  pythonImportsCheck = [ "langchain_core" ];

  # PyPI source does not have tests
  doCheck = false;

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/core";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
