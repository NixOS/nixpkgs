{
  lib,
  aiohttp,
  aiohttp-socks,
  beautifulsoup4,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  playwright-stealth,
  playwright,
  poetry-core,
  puremagic,
  pydub,
  pythonOlder,
  pytz,
  requests,
  setuptools,
  speechrecognition,
  tzdata,
  w3lib,
}:

buildPythonPackage rec {
  pname = "playwrightcapture";
  version = "1.28.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    tag = "v${version}";
    hash = "sha256-w3ZQqur/fj36n64Li/qNnhJ8b7Lu3cna2eNj4hxhZ/8=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "aiohttp-socks"
    "beautifulsoup4"
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
    playwright
    playwright-stealth
    puremagic
    pytz
    requests
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
    changelog = "https://github.com/Lookyloo/PlaywrightCapture/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
