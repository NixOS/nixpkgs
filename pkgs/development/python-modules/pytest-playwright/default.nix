{ lib
, fetchFromGitHub
, buildPythonPackage
, playwright
, playwright-driver
, pytest
, pytest-base-url
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools-scm
, django
}:

buildPythonPackage rec {
  pname = "pytest-playwright";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-pytest";
    rev = "refs/tags/v${version}";
    hash = "sha256-5qjfZGDM1OqXXNyj81O49ClKKGiAPdgyZZu6TgpskGs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    playwright
    pytest-base-url
    python-slugify
  ];

  # Most of the tests rely on network access, or on unavailable browsers such as
  # msedge, chrome or webkit
  doCheck = false;

  preCheck = ''
    export PLAYWRIGHT_BROWSERS_PATH=${playwright-driver.browsers}
  '';

  pythonImportsCheck = [
    "pytest_playwright"
  ];

  meta = with lib; {
    description = "Pytest plugin to write end-to-end browser tests with Playwright";
    homepage = "https://github.com/microsoft/playwright-pytest";
    changelog = "https://github.com/microsoft/playwright-pytest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sephi ];
  };
}
