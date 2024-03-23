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
  version = "1.23.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PlaywrightCapture";
    rev = "refs/tags/v${version}";
    hash = "sha256-jNTVdGrUQaYHgTxz6zYTdxNQoXEfy/zshherC/gGmng=";
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "playwright"
    "setuptools"
    "tzdata"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
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
