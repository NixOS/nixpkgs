{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  logistro,
  platformdirs,
  simplejson,

  # bundled browser (no chromium on Darwin, so use brave)
  brave,

  # tests
  numpy,
  pytestCheckHook,
  pytest-asyncio,
  async-timeout,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "choreographer";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "choreographer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CGIH3tkRX9wheZeUXA+eW4yS8Lmee6W/R0pfJySpKHQ=";
  };

  patches = [
    # Inject browser path from nix
    ./inject-browser.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
    substituteInPlace src/choreographer/utils/_which.py \
      --replace-fail '@NIX_BROWSER_PATH@' "${lib.getExe brave}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    logistro
    platformdirs
    simplejson
    brave
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pytest-asyncio
    async-timeout
    writableTmpDirAsHomeHook
    # pytest-xdist causes deadlock
  ];

  pytestFlags = [
    "-vv"
  ];

  enabledTestPaths = [
    "tests/"
  ];

  # N.B. Most tests fail in the sandbox, but work with it disabled (browser needs system resources)
  disabledTests = [
    # AssertionError: assert 'brave' == 'chrome'
    "test_internal"
    # Looks for a browser named "chrome" but we have "brave"
    "test_canary"
    # Watchdog timer race condition causes test to fail
    # (logging claims a BrowserFailedError issue, but the underlying condition is async execution cancelled)
    "test_context"
    "test_no_context"
    "test_watchdog"
    # RuntimeError: Temporary directory not deleted successfully
    "test_subscribe_and_unsubscribe"
    # asyncio.exceptions.CancelledError
    "test_unsubscribe"
    "test_placeholder"
    "test_session_send_command"
  ];

  # These all fail in the sandbox
  disabledTestPaths = [
    # fails in the sandbox (browser needs system resources)
    "tests/test_browser.py"
    "tests/test_chunking.py"
    # asyncio.exceptions.CancelledError (the cause of all the browser failures)
    "tests/test_devtools_async_helpers.py"
    "tests/test_tab.py"
  ];

  pythonImportsCheck = [ "choreographer" ];

  meta = {
    description = "Devtools Protocol implementation for chrome";
    homepage = "https://github.com/plotly/choreographer";
    changelog = "https://github.com/plotly/choreographer/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      sarahec
    ];
  };
})
