{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonAtLeast,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyncstdlib";
  version = "3.13.3";
  pyproject = true;

  # https://github.com/maxfischer2781/asyncstdlib/issues/189
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = "asyncstdlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3mM97zB/pEw8/kPO6jUL7dz6Q7kVatfsURy+5zSq9Bs=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "asyncstdlib" ];

  meta = {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    changelog = "https://github.com/maxfischer2781/asyncstdlib/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
