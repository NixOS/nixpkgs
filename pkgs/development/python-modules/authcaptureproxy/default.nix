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
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alandtse";
    repo = "auth_capture_proxy";
    rev = "v${version}";
    sha256 = "1fbrmh6qa3dm3q3zdxaa0fls94wardbcvnjgwxk686wpjgs1xrs4";
  };

  postPatch = ''
    # https://github.com/alandtse/auth_capture_proxy/issues/14
    substituteInPlace pyproject.toml --replace \
      "poetry.masonry.api" \
      "poetry.core.masonry.api"
  '';

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

  checkInputs = [
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
