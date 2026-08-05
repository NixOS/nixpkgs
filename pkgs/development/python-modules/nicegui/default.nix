{
  lib,
  aiofiles,
  aiohttp,
  buildPythonPackage,
  certifi,
  docutils,
  fastapi,
  fetchFromGitHub,
  httpx,
  ifaddr,
  itsdangerous,
  jinja2,
  libsass,
  lxml-html-clean,
  lxml,
  markdown2,
  matplotlib,
  orjson,
  pandas,
  pkgs,
  plotly,
  poetry-core,
  poetry-dynamic-versioning,
  polars,
  pyecharts,
  pygments,
  pytest-asyncio,
  pytest-selenium,
  pytestCheckHook,
  python-dotenv,
  python-multipart,
  python-socketio,
  pywebview,
  redis,
  requests,
  setuptools,
  tinycss2,
  typing-extensions,
  urllib3,
  uvicorn,
  vbuild,
  watchfiles,
  webdriver-manager,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nicegui";
  version = "3.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pm8jUDdpRvPDVwHXHGwuqPogpE/HMS19uJ5beWch7TE=";
  };

  pythonRelaxDeps = [
    "idna"
    "lxml"
    "orjson"
    "python-multipart"
    "requests"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
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
    lxml
    lxml-html-clean
    markdown2
    orjson
    pygments
    python-dotenv
    python-multipart
    python-socketio
    requests
    tinycss2
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
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "nicegui" ];

  # chromedriver release doesn't seems to be supported, try with next release
  doCheck = false;

  meta = {
    description = "Module to create web-based user interfaces";
    homepage = "https://github.com/zauberzeug/nicegui/";
    changelog = "https://github.com/zauberzeug/nicegui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
