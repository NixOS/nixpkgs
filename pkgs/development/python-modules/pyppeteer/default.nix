{
  lib,
  appdirs,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  importlib-metadata,
  poetry-core,
  pyee,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  syncer,
  tqdm,
  urllib3,
  websockets,
}:

buildPythonPackage rec {
  pname = "pyppeteer";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyppeteer";
    repo = "pyppeteer";
    tag = version;
    hash = "sha256-LYyV4Wzz4faewSsGjNe0i/9BLbCHzzEns2ZL2MYkGWw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'pyee = "^11.0.0"' 'pyee = "*"' \
      --replace-fail 'urllib3 = "^1.25.8"' 'urllib3 = "*"' \
      --replace-fail 'websockets = "^10.0"' 'websockets = "*"'
  '';

  nativeBuildInputs = [ poetry-core ];

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

  pythonImportsCheck = [ "pyppeteer" ];

  meta = {
    description = "Headless chrome/chromium automation library (unofficial port of puppeteer)";
    mainProgram = "pyppeteer-install";
    homepage = "https://github.com/pyppeteer/pyppeteer";
    changelog = "https://github.com/pyppeteer/pyppeteer/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
