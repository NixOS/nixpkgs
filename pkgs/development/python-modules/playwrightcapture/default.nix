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
  version = "1.25.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    rev = "refs/tags/v${version}";
    hash = "sha256-O482RKJejgg3eJe4M9U0ExuDFwFz9Fbpxvrn6re58h8=";
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

  passthru.optional-dependencies = {
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
