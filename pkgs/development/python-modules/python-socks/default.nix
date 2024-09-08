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
  trio,
  trustme,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-socks";
  version = "2.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.6.2";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "python-socks";
    rev = "refs/tags/v${version}";
    hash = "sha256-c1fjSHi7LvaOeZwTOTSY/ZVr27/j03CdAra1PSa9Jt0=";
  };

  propagatedBuildInputs = [
    trio
    curio
    async-timeout
  ];

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
