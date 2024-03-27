{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai";
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_openai";
    inherit version;
    hash = "sha256-wP2TIlWsm/crawLDgR7rvzQxqnYDrqqzHIEVR/REsco=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.llms.openai"
  ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
