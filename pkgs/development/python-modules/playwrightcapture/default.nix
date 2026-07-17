{
  lib,
  aiohttp-socks,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  dateparser,
  dnspython,
  fetchFromGitHub,
  lookyloo-models,
  orjson,
  playwright-stealth,
  playwright,
  poetry-core,
  pure-magic-rs,
  pydub,
  pyfaup-rs,
  pytz,
  requests,
  rfc3161-client,
  setuptools,
  speechrecognition,
  tzdata,
  w3lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "playwrightcapture";
  version = "1.40.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gqid9Pei8c8llX2r29kdr/ruSU7967Rbzc3RF1PBLNI=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "aiohttp-socks"
    "beautifulsoup4"
    "orjson"
    "playwright"
    "setuptools"
    "tzdata"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiohttp-socks
    beautifulsoup4
    dateparser
    dnspython
    lookyloo-models
    orjson
    playwright
    playwright-stealth
    pure-magic-rs
    pyfaup-rs
    pytz
    requests
    rfc3161-client
    setuptools
    tzdata
    w3lib
  ];

  optional-dependencies = {
    recaptcha = [
      speechrecognition
      pydub
      requests
    ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "playwrightcapture" ];

  meta = {
    description = "Capture a URL with Playwright";
    homepage = "https://github.com/Lookyloo/PlaywrightCapture";
    changelog = "https://github.com/Lookyloo/PlaywrightCapture/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
