{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic-monty-client,
  pydantic-monty-runtime,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-monty";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "monty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FqJIkEVmKeDWQyb/yrJ0+/2tZ1kCNe2Xc4r9UPgQptU=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/pydantic-monty";

  build-system = [ hatchling ];

  dependencies = [
    pydantic-monty-client
    pydantic-monty-runtime
  ];

  # tests are in the subpackages
  doCheck = false;

  pythonImportsCheck = [ "pydantic_monty" ];

  meta = {
    description = "Monty, the Python sandbox: bindings plus the worker binary";
    homepage = "https://github.com/pydantic/monty/tree/main/packages/pydantic-monty";
    changelog = "https://github.com/pydantic/monty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ squat ];
  };
})
