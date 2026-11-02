{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "async-cache";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamsinghrajat";
    repo = "async-cache";
    tag = finalAttrs.version;
    hash = "sha256-3SPepAlXJxufTgNqwxh/c2jhL/j9/omqOZElHhDiIIw=";
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
