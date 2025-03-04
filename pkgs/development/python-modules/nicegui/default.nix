{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  setuptools,

  # dependencies
  aiofiles,
  aiohttp,
  certifi,
  docutils,
  fastapi,
  httpx,
  ifaddr,
  itsdangerous,
  jinja2,
  markdown2,
  orjson,
  pygments,
  python-multipart,
  python-socketio,
  requests,
  typing-extensions,
  urllib3,
  uvicorn,
  vbuild,
  watchfiles,

  # optional-dependencies
  matplotlib,
  pywebview,
  plotly,
  libsass,
  redis,

  # tests
  pandas,
  pkgs,
  polars,
  pyecharts,
  pytest-asyncio,
  pytest-selenium,
  pytestCheckHook,
  webdriver-manager,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "nicegui";
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui";
    tag = "v${version}";
    hash = "sha256-te2YMKOnvmo2FCdIB1lvqcVsHBD4k5KK10E2Bol6uEg=";
  };

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
    redis = [ redis ];
  };

  nativeCheckInputs = [
    pandas
    pkgs.chromedriver
    polars
    pyecharts
    pytest-asyncio
    pytest-selenium
    pytestCheckHook
    webdriver-manager
    writableTmpDirAsHomeHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "nicegui" ];

  # chromedriver release doesn't seems to be supported, try with next release
  doCheck = false;

  meta = {
    description = "Module to create web-based user interfaces";
    homepage = "https://github.com/zauberzeug/nicegui/";
    changelog = "https://github.com/zauberzeug/nicegui/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
