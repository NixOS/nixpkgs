{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, llama-index-llms-openai
, poetry-core
, pythonOlder
, transformers
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai-like";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_openai_like";
    inherit version;
    hash = "sha256-w0EjJQd8dSY+N9YNUBMUub3HcPEtiisW51bn2ayPnj8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
    transformers
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.llms.openai_like"
  ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for OpenAI like";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai-like";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
