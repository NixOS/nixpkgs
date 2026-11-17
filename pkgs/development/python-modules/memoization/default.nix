{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "memoization";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lonelyenvoy";
    repo = "python-memoization";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pVqaeXdlVstF36YogRJxvxS6WnFLajKzRajaWFn+Hw8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "memoization" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  meta = {
    description = "Powerful caching library for Python, with TTL support and multiple algorithm options";
    homepage = "https://github.com/lonelyenvoy/python-memoization";
    changelog = "https://github.com/lonelyenvoy/python-memoization/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
