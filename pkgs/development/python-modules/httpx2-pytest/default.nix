{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  httpx2,
  pytest,

  # check inputs
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

# CAUTION: There is also a `pytest-httpx2` repo that exposes a different API.
buildPythonPackage (finalAttrs: {
  pname = "httpx2-pytest";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "angryfoxx";
    repo = "httpx2-pytest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EWoigrWtUVTBePEDAeJjeWnD+afEGs0wdSSY1RW5Q1w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx2
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "pytest_httpx2"
  ];

  meta = {
    description = "Pytest-httpx fork for httpx2";
    homepage = "https://github.com/angryfoxx/httpx2-pytest";
    changelog = "https://github.com/angryfoxx/httpx2-pytest/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
