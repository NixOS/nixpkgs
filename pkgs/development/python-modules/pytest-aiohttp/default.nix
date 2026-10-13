{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  aiohttp,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-aiohttp";
  version = "1.1.1";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "pytest-aiohttp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SYMwVmcgPLOasW6TQGqqNO+sbp8zQQtDHb3IyAVO6KI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    aiohttp
    pytest-asyncio
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::pytest.PytestDeprecationWarning"
  ];

  meta = {
    homepage = "https://github.com/aio-libs/pytest-aiohttp/";
    changelog = "https://github.com/aio-libs/pytest-aiohttp/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Pytest plugin for aiohttp support";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
