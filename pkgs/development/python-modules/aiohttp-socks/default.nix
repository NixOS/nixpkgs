{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, aiohttp
, python-socks
, attrs
, pytestCheckHook
, pytest-asyncio
, trustme
, flask
, anyio
, tiny-proxy
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.8.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "aiohttp-socks";
    rev = "v${version}";
    hash = "sha256-KQeZxwxvWvjS24DoS6G/AIZ9tCpZZtnpJ8adVB+TQpA=";
  };

  propagatedBuildInputs = [ aiohttp python-socks ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    trustme
    flask
    anyio
    tiny-proxy
  ];

  pythonImportsCheck = [ "aiohttp_socks" ];

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
