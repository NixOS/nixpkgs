{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, anyio
, jsonpatch
, langsmith
, packaging
, pydantic
, pythonRelaxDepsHook
, pyyaml
, requests
, tenacity
}:

buildPythonPackage rec {
  pname = "langchain-core";
  version = "0.1.28";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "langchain_core";
    inherit version;
    hash = "sha256-BOdhpRMgC25bWBhhOCGUV5nAe8U0kIfXaS5QgjEHydY=";
  };

  pythonRelaxDeps = [
    "langsmith"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    anyio
    jsonpatch
    langsmith
    packaging
    pydantic
    pyyaml
    requests
    tenacity
  ];

  pythonImportsCheck = [
    "langchain_core"
  ];

  # PyPI source does not have tests
  doCheck = false;

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/core";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
