{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, llama-parse
, poetry-core
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "llama-index-readers-llama-parse";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_llama_parse";
    inherit version;
    hash = "sha256-eGCLGTyBiJSu/u4KowPwK3+A8uTK8Thmwv07CxAj4sA=";
  };

  pythonRelaxDeps = [
    "llama-parse"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    llama-parse
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.readers.llama_parse"
  ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-llama-parse";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
