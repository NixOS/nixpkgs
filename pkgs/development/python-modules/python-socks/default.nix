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
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "python-socks";
    rev = "refs/tags/v${version}";
    hash = "sha256-QPA7Ge1eJa5YxpD8OLAYkV7fvwgPxA5Z+OlyKr3F5Vg=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    anyio = [ anyio ];
    asyncio = [ async-timeout ];
    curio = [ curio ];
    trio = [ trio ];
  };

  nativeCheckInputs = [
    anyio
    flask
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    trustme
    yarl
  ];

  doCheck = false; # requires tiny_proxy module

  pythonImportsCheck = [ "python_socks" ];

  meta = with lib; {
    description = "Core proxy client (SOCKS4, SOCKS5, HTTP) functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    changelog = "https://github.com/romis2012/python-socks/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
