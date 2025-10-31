{
  lib,
  buildPythonPackage,
  eval-type-backport,
  fetchPypi,
  hatchling,
  llama-index-instrumentation,
  pydantic,
}:

buildPythonPackage rec {
  pname = "llama-index-workflows";
  version = "2.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_workflows";
    inherit version;
    hash = "sha256-1v+t/zIhKSYhNilczcQpJnFPzt+0dc4So6VRGljc5oI=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ hatchling ];

  dependencies = [
    eval-type-backport
    llama-index-instrumentation
    pydantic
  ];

  pythonImportsCheck = [ "workflows" ];

  meta = {
    description = "Event-driven, async-first, step-based way to control the execution flow of AI applications like Agents";
    homepage = "https://pypi.org/project/llama-index-workflows/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
