{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  click,
  pydantic,

  thefuzz,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbgpu";
  version = "2025.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1KL9w2/1/yrzfo/Yo+B0CrKvc8xeD9oZn9/z1vFob04=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    pydantic
  ];

  optional-dependencies = {
    fuzz = [ thefuzz ];
  };

  pythonImportsCheck = [ "dbgpu" ];

  meta = {
    description = "Small, easy-to-use open source database of over 2000 GPUs with architecture, manufacturing, API support and performance details";
    homepage = "https://github.com/painebenjamin/dbgpu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "dbgpu";
  };
})
