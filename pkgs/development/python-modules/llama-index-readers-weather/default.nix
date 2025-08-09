{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pyowm,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-weather";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_weather";
    inherit version;
    hash = "sha256-oGk2M/YaVm8pY4JDFOWGkKbDhEfd/OYBgWLSzV3peAQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    llama-index-core
    pyowm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.weather" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for Weather";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-weather";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
