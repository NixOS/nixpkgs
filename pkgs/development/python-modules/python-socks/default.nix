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
  pythonOlder,
  pytestCheckHook,
  setuptools,
  trio,
  trustme,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-socks";
  version = "2.5.3";
  pyproject = true;

  disabled = pythonOlder "3.6.2";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "python-socks";
    rev = "refs/tags/v${version}";
    hash = "sha256-KpL3MAPbeKQh/NZyXlAAB6O7ljx1bVMBRO8fGJT2Zvo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    trio
    curio
    async-timeout
  ];

  optional-dependencies = {
    asyncio = lib.optionals (pythonOlder "3.11") [ async-timeout ];
    trio = [ trio ];
    curio = [ curio ];
    anyio = [ anyio ];
  };

  doCheck = false; # requires tiny_proxy module

  nativeCheckInputs = [
    anyio
    flask
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    trustme
    yarl
  ];

  pythonImportsCheck = [ "python_socks" ];

  meta = with lib; {
    changelog = "https://github.com/romis2012/python-socks/releases/tag/v${version}";
    description = "Core proxy client (SOCKS4, SOCKS5, HTTP) functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
