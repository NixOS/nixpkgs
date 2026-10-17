{
  lib,
  anyio,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
  setuptools,
  starlette,
  tiny-proxy,
  trio,
  trustme,
  uvicorn,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-socks";
  version = "3.1.1";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "python-socks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4+3z/n8DTVRK0/f/MNy8gvnRwA69WwPvLSCFEN/dOvk=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    asyncio = [ ];
    trio = [ trio ];
    anyio = [ anyio ];
  };

  nativeCheckInputs = [
    anyio
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    starlette
    tiny-proxy
    trustme
    uvicorn
    yarl
  ];

  pythonImportsCheck = [ "python_socks" ];

  meta = {
    description = "Core proxy client (SOCKS4, SOCKS5, HTTP) functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    changelog = "https://github.com/romis2012/python-socks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
