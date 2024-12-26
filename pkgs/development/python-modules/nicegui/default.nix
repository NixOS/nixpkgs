{
  lib,
  aiofiles,
  aiohttp,
  buildPythonPackage,
  certifi,
  pkgs,
  docutils,
  fastapi,
  fetchFromGitHub,
  httpx,
  ifaddr,
  itsdangerous,
  jinja2,
  libsass,
  markdown2,
  matplotlib,
  orjson,
  pandas,
  plotly,
  poetry-core,
  pyecharts,
  pygments,
  pytest-asyncio,
  pytest-selenium,
  pytestCheckHook,
  python-multipart,
  python-socketio,
  pythonOlder,
  pywebview,
  requests,
  setuptools,
  typing-extensions,
  urllib3,
  uvicorn,
  vbuild,
  watchfiles,
  webdriver-manager,
}:

buildPythonPackage rec {
  pname = "nicegui";
  version = "2.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui";
    rev = "refs/tags/v${version}";
    hash = "sha256-oT191QVpvE5xszgBFt3o4A2hU50zmzPUywmAQuKZ5OE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=30.3.0,<50",' ""
  '';

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    aiofiles
    aiohttp
    certifi
    docutils
    fastapi
    httpx
    ifaddr
    itsdangerous
    jinja2
    markdown2
    orjson
    pygments
    python-multipart
    python-socketio
    requests
    typing-extensions
    urllib3
    uvicorn
    vbuild
    watchfiles
  ];

  optional-dependencies = {
    # Circular dependency
    # highcharts = [ nicegui-highcharts ];
    matplotlib = [ matplotlib ];
    native = [ pywebview ];
    plotly = [ plotly ];
    sass = [ libsass ];
  };

  nativeCheckInputs = [
    pandas
    pkgs.chromedriver
    pyecharts
    pytest-asyncio
    pytest-selenium
    pytestCheckHook
    webdriver-manager
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "nicegui" ];

  # chromedriver release doesn't seems to be supported, try with next release
  doCheck = false;

  meta = {
    description = "Module to create web-based user interfaces";
    homepage = "https://github.com/zauberzeug/nicegui/";
    changelog = "https://github.com/zauberzeug/nicegui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
