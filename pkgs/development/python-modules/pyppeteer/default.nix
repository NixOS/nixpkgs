{ lib
, appdirs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "0.2.5";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1hl4rw8j5yiak0d34vx1l1blr8125bscjd8m46a5m8xzm98csjc7";
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

  patches = [
    # Switch to poetry-core, https://github.com/pyppeteer/pyppeteer/pull/262
    (fetchpatch {
      name = "switch-poetry-core.patch";
      url = "https://github.com/pyppeteer/pyppeteer/commit/e248baebefcf262fd96f261d940e74ed49ba2df9.patch";
      sha256 = "03g8n35kn2alqki37s0hf2231fk2zkr4nr1x1g2rfrhps9d6fyvw";
    })
  ];

  postPatch = ''
    # https://github.com/pyppeteer/pyppeteer/pull/252
    substituteInPlace pyproject.toml \
      --replace 'websockets = "^8.1"' 'websockets = "*"'
  '';

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
