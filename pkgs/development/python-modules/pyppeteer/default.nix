{ lib
, appdirs
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.2.6";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-mMFQp8GMjKUc3yyB4c8Tgxut7LkMFa2cySO3iSA/aI4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    appdirs
    pyee
    tqdm
    urllib3
    websockets
  ];

  checkInputs = [
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
    homepage = "https://github.com/pyppeteer/pyppeteer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
