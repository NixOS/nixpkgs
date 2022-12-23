{ lib
, fetchFromGitHub
, buildPythonPackage
, playwright
, pytest
, pytest-base-url
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools-scm
, python
, django
}:

buildPythonPackage rec {
  pname = "pytest-playwright";
  version = "0.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-pytest";
    rev = "v${version}";
    hash = "sha256-fHzQxbQBSEkCFu/ualjzSmIt3SiEa2ktTvIJKPZLT9Q=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ playwright pytest-base-url python-slugify ];

  # Most of the tests rely on network access, or on unavailable browsers such as
  # msedge, chrome or webkit
  doCheck = false;

  preCheck = ''
    export PLAYWRIGHT_BROWSERS_PATH=${playwright.browsers}
  '';

  pythonImportsCheck = [ "pytest_playwright" ];

  meta = with lib; {
    description = "Pytest plugin to write end-to-end browser tests with Playwright";
    homepage = "https://github.com/microsoft/playwright-pytest";
    license = licenses.asl20;
    maintainers = with maintainers; [ sephi ];
  };
}
