{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, llama-index-llms-openai
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-multi-modal-llms-openai";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_multi_modal_llms_openai";
    inherit version;
    hash = "sha256-al1lhMM6nRsGz1yHTGOvJgP8k7ZgveSBqMVH6HbG4sM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.multi_modal_llms.openai"
  ];

  meta = with lib; {
    description = "LlamaIndex Multi-Modal-Llms Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/multi_modal_llms/llama-index-multi-modal-llms-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
