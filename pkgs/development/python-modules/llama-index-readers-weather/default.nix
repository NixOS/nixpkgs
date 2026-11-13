{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
  pyowm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-weather";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_weather";
    inherit version;
    hash = "sha256-YaE2uqNwfo2M0h32ZepOquWV87Q37HEO2/Mfndm8U9c=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    pyowm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.weather" ];

  meta = {
    description = "LlamaIndex Readers Integration for Weather";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-weather";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
