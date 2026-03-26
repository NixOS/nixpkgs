{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "async-cache";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamsinghrajat";
    repo = "async-cache";
    tag = finalAttrs.version;
    hash = "sha256-lkjxdx/VePkJCZFFKLjtb9a33XzhHGiRWe5H35uMUFg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "cache" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Caching solution for asyncio";
    homepage = "https://github.com/iamsinghrajat/async-cache";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lukegb ];
  };
})
