{ lib
, beautifulsoup4
, buildPythonPackage
, dateparser
, fetchFromGitHub
, playwright
, playwright-stealth
, poetry-core
, puremagic
, pydub
, pythonOlder
, pythonRelaxDepsHook
, pytz
, requests
, setuptools
, speechrecognition
, tzdata
, w3lib
}:

buildPythonPackage rec {
  pname = "playwrightcapture";
  version = "1.24.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    rev = "refs/tags/v${version}";
    hash = "sha256-+2BxXgIC595FM3FDIbFjFpWIEkqQrDILWFjQkyN5nao=";
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "playwright"
    "setuptools"
    "tzdata"
  ];

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  dependencies = [
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

  pythonImportsCheck = [
    "playwrightcapture"
  ];

  meta = with lib; {
    description = "Capture a URL with Playwright";
    homepage = "https://github.com/Lookyloo/PlaywrightCapture";
    changelog = "https://github.com/Lookyloo/PlaywrightCapture/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
