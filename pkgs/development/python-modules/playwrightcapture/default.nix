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
<<<<<<< HEAD
  version = "1.36.0";
=======
  version = "1.35.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Iqk7VFhlmzjQPvm08HwYkopV9Q/TNwSVedGH5GiMdWE=";
=======
    hash = "sha256-P2d2RY4A5Yxug1Rj5UmXBW5esEdk0M1wZyOBPKtJslA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Capture a URL with Playwright";
    homepage = "https://github.com/Lookyloo/PlaywrightCapture";
    changelog = "https://github.com/Lookyloo/PlaywrightCapture/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Capture a URL with Playwright";
    homepage = "https://github.com/Lookyloo/PlaywrightCapture";
    changelog = "https://github.com/Lookyloo/PlaywrightCapture/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
