{ lib
, appdirs
, buildPythonPackage
, certifi
, fetchFromGitHub
, importlib-metadata
, poetry-core
, pyee
, pytest-xdist
, pytestCheckHook
, pythonOlder
, syncer
, tqdm
, urllib3
, websockets
}:

buildPythonPackage rec {
  pname = "pyppeteer";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyppeteer";
    repo = "pyppeteer";
    rev = "refs/tags/${version}";
    hash = "sha256-izMaWtJdkLHMQbyq7o7n46xB8dOHXZ5uO0UXt+twjL4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pyee = "^8.1.0"' 'pyee = "*"' \
      --replace 'urllib3 = "^1.25.8"' 'urllib3 = "*"' \
      --replace 'websockets = "^10.0"' 'websockets = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    appdirs
    certifi
    importlib-metadata
    pyee
    tqdm
    urllib3
    websockets
  ];

  nativeCheckInputs = [
    syncer
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_browser.py"
    "tests/test_browser_context.py"
    "tests/test_connection.py"
    "tests/test_coverage.py"
    "tests/test_dialog.py"
    "tests/test_element_handle.py"
    "tests/test_execution_context.py"
    "tests/test_frame.py"
    "tests/test_input.py"
    "tests/test_launcher.py"
    "tests/test_network.py"
    "tests/test_page.py"
    "tests/test_pyppeteer.py"
    "tests/test_target.py"
    "tests/test_tracing.py"
    "tests/test_worker.py"
  ];

  disabledTests = [
    # Requires network access
    "TestScreenShot"
    "TestBrowserCrash"
    "TestPDF"
  ];

  pythonImportsCheck = [
    "pyppeteer"
  ];

  meta = with lib; {
    description = "Headless chrome/chromium automation library (unofficial port of puppeteer)";
    homepage = "https://github.com/pyppeteer/pyppeteer";
    changelog = "https://github.com/pyppeteer/pyppeteer/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
