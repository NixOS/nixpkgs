{
  lib,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchPypi,
  poetry-core,
  llama-cpp-python,
  llama-index-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-llama-cpp";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_llama_cpp";
    inherit version;
    hash = "sha256-1kDoUV0H/713zwB6SG86ZJilfQZHbG0JUuoWAYX9Qtc=";
  };

  build-system = [
    poetry-core
  ];

  pythonRemoveDeps = [
    "llama-cpp-python"
    "llama-index-core"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  dependencies = [
    llama-cpp-python
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.llms.llama_cpp"
  ];

  meta = {
    description = "Llama-index llms llama cpp integration";
    homepage = "https://pypi.org/project/llama-index-llms-llama-cpp/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
