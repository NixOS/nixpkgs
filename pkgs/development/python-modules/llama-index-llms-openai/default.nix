{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_openai";
    inherit version;
    hash = "sha256-E8hdTPEr0Hueq5gFy8Qt+y410N/J3CZyDt0b3xwRKlQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.openai" ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
