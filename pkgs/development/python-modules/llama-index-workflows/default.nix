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
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_workflows";
    inherit version;
    hash = "sha256-B6aM9YBA1GmvjQX1YhdBiuZARVfwJUv/IqdIGYeBjj8=";
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
    description = "An event-driven, async-first, step-based way to control the execution flow of AI applications like Agents";
    homepage = "https://pypi.org/project/llama-index-workflows/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
