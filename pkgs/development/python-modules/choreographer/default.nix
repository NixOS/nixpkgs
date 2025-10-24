{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  makeWrapper,

  # build-system
  setuptools,
  setuptools-git-versioning,

  # dependencies
  logistro,
  platformdirs,
  simplejson,

  # tests
  async-timeout,
  numpy,
  pytest-asyncio,
  pytestCheckHook,

  browser ? cefsimple,
  cefsimple,
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

  patches = [ ./headless-ozone.patch ];

  postPatch = ''
    substituteInPlace src/choreographer/browsers/chromium.py \
      --replace-fail '"""Find a chromium based browser."""' \
                     '"""Find a chromium based browser."""
            return os.environ.get("BROWSER_PATH", "${placeholder "out"}/libexec/choreographer/browser")'
  '';

  nativeBuildInputs = [ makeWrapper ];

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    logistro
    platformdirs
    simplejson
  ];

  postInstall = ''
    makeWrapper ${lib.getExe browser} $out/libexec/choreographer/browser \
      --add-flags "--url=about:blank"
  '';

  nativeCheckInputs = [
    async-timeout
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  # No display in the build sandbox, and builders may be slow
  preCheck = ''
    substituteInPlace tests/conftest.py \
      --replace-fail '@pytest.fixture(params=[True, False], ids=["headless", ""])' \
                     '@pytest.fixture(params=[True], ids=["headless"])' \
      --replace-fail 'pytest.default_timeout = 24' 'pytest.default_timeout = 120'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Chromium's sandbox can't load the store-symlinked CEF framework; test
    # only --no-sandbox on macOS (how kaleido drives it anyway).
    substituteInPlace tests/conftest.py \
      --replace-fail '@pytest.fixture(params=[True, False], ids=["enable_sandbox", ""])' \
                     '@pytest.fixture(params=[False], ids=[""])'
  '';

  disabledTests = [
    # Assume the browser is found by searching PATH
    "test_internal"
    "test_canary"
    # Require network access
    "test_create_and_wait"
    "test_navigate_and_wait"
  ];

  pythonImportsCheck = [ "choreographer" ];

  # Browser tests can't run in the macOS build sandbox: no headless backend
  # (no Ozone) and CEF aborts on the sandbox-denied system appearance,
  # WindowServer and IOKit. Gated so it is only set when those checks run.
  __noChroot = stdenv.hostPlatform.isDarwin && finalAttrs.doInstallCheck;

  passthru = {
    inherit browser;
  };

  meta = {
    description = "Devtools Protocol implementation for chrome";
    homepage = "https://github.com/plotly/choreographer";
    changelog = "https://github.com/plotly/choreographer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
