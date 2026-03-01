{
  lib,
  async-timeout,
  buildPythonPackage,
  curio,
  fetchFromGitHub,
  anyio,
  flask,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
  setuptools,
  tiny-proxy,
  trio,
  trustme,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-socks";
  version = "2.8.1";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "python-socks";
    tag = "v${version}";
    hash = "sha256-Eu4xeBZbZvAGfFArMiUlUQQa4yywKWj+azv+OHiKJfU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    trio
    curio
    async-timeout
  ];

  optional-dependencies = {
    trio = [ trio ];
    curio = [ curio ];
    anyio = [ anyio ];
  };

  nativeCheckInputs = [
    anyio
    flask
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    tiny-proxy
    trustme
    yarl
  ];

  pythonImportsCheck = [ "python_socks" ];

  meta = {
    changelog = "https://github.com/romis2012/python-socks/releases/tag/${src.tag}";
    description = "Core proxy client (SOCKS4, SOCKS5, HTTP) functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
