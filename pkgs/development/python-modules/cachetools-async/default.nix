{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  cachetools,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov,
}:
buildPythonPackage (finalAttrs: {
  pname = "cachetools-async";
  version = "0.0.5";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "imnotjames";
    repo = "cachetools-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mZrgVE9ctGdXIjBfazbg2kYwP0gV/j4qDfel4Oarldg=";
  };

  build-system = [ hatchling ];

  dependencies = [ cachetools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
  ];

  pythonImportCheck = true;
  meta = {
    description = "Decorators for caching asyncio functions and methods, inspired by cachetools";
    homepage = "https://github.com/imnotjames/cachetools-async";
    changelog = "https://github.com/imnotjames/cachetools-async/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
