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
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alandtse";
    repo = "auth_capture_proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-OY6wT0xi7f6Bn8VOL9+6kyv5cENYbrGGTWWKc6o36cw=";
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

  disabledTests = [
    # test fails with frequency 1/200
    # https://github.com/alandtse/auth_capture_proxy/issues/25
    "test_return_timer_countdown_refresh_html"
  ];

  pythonImportsCheck = [
    "authcaptureproxy"
  ];

  meta = with lib; {
    changelog = "https://github.com/alandtse/auth_capture_proxy/releases/tag/v${version}";
    description = "A proxy to capture authentication information from a webpage";
    homepage = "https://github.com/alandtse/auth_capture_proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ graham33 hexa ];
  };
}
