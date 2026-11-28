{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  httpx2,
  pillow,
  protobuf,
  pydantic,
  pydantic-extra-types,
  pydantic-settings,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typing-extensions,
  websockets,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "busylib";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "busy-app";
    repo = "busylib-py";
    tag = finalAttrs.version;
    hash = "sha256-Sg7Z3vbvF5zrNnemsUAWldc5v43VfatT4uhVXf8e9w0=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    httpx2
    protobuf
    pydantic
    pydantic-extra-types
    pydantic-settings
    typing-extensions
    websockets
    zeroconf
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    media = [ pillow ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.aiohttp
  ++ finalAttrs.passthru.optional-dependencies.media;

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "busylib" ];

  meta = {
    description = "Python library for Busy Bar API";
    homepage = "https://github.com/busy-app/busylib-py";
    changelog = "https://github.com/busy-app/busylib-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
