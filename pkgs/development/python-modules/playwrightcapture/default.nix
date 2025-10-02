{
  lib,
  aiohttp-socks,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  dateparser,
  dnspython,
  fetchFromGitHub,
  orjson,
  playwright-stealth,
  playwright,
  poetry-core,
  puremagic,
  pydub,
  pytz,
  requests,
  rfc3161-client,
  setuptools,
  speechrecognition,
  tzdata,
  w3lib,
}:

buildPythonPackage rec {
  pname = "playwrightcapture";
  version = "1.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    tag = "v${version}";
    hash = "sha256-ivzyE5+wc9AcgfSLliQmc6wXtcaEYCOAJmwk+kHV0Gw=";
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
    orjson
    playwright
    playwright-stealth
    puremagic
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

  meta = with lib; {
    description = "Capture a URL with Playwright";
    homepage = "https://github.com/Lookyloo/PlaywrightCapture";
    changelog = "https://github.com/Lookyloo/PlaywrightCapture/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
