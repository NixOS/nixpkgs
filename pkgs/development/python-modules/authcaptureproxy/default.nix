{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, aiohttp
, beautifulsoup4
, httpx
, importlib-metadata
, multidict
, typer
, yarl
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "authcaptureproxy";
  version = "1.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alandtse";
    repo = "auth_capture_proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-4IPBulzRoAAplyM/1MPE40IW4IXBIGYLydzpY64Gl0c=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    httpx
    importlib-metadata
    multidict
    typer
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A proxy to capture authentication information from a webpage";
    homepage = "https://github.com/alandtse/auth_capture_proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ graham33 hexa ];
  };
}
