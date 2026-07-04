{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  importlib-metadata,
  numpy,
  platformdirs,
  typing-extensions,
  wasmtime,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itkwasm";
  version = "1.0b195";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1OQ0SieMEcrWiIgWT1dQxXdk9lCbWD+1xJ0jfIr0isU=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [
    importlib-metadata
    numpy
    platformdirs
    typing-extensions
    wasmtime
  ];

  # No test available
  doCheck = false;

  pythonImportsCheck = [ "itkwasm" ];

  meta = {
    description = "Python interface to itk-wasm WebAssembly (Wasm) modules";
    homepage = "https://pypi.org/project/itkwasm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
