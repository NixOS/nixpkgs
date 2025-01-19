{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  playwright,
  playwright-driver,
  pytest,
  pytest-base-url,
  python-slugify,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-playwright";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-pytest";
    tag = "v${version}";
    hash = "sha256-/FTAnnVDf9fonNme5SM+9EKa39DtF64pclCts6tTjz0=";
  };

  postPatch = ''
    pushd pytest-playwright

    substituteInPlace pyproject.toml --replace-fail "==" ">="
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    playwright
    pytest-base-url
    python-slugify
  ];

  # Most of the tests rely on network access, or on unavailable browsers such as
  # msedge, chrome or webkit
  doCheck = false;

  preCheck = ''
    popd
    export PLAYWRIGHT_BROWSERS_PATH=${playwright-driver.browsers}
  '';

  pythonImportsCheck = [ "pytest_playwright" ];

  meta = with lib; {
    description = "Pytest plugin to write end-to-end browser tests with Playwright";
    homepage = "https://github.com/microsoft/playwright-pytest";
    changelog = "https://github.com/microsoft/playwright-pytest/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sephi ];
  };
}
