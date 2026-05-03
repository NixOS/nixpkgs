{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,
  setuptools-git-versioning,

  # dependencies
  logistro,
  simplejson,
  pytestCheckHook,
  pytest-asyncio,
  async-timeout,
  numpy,

  # Runtime dependencies
  ungoogled-chromium,
  
  # update script
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "choreographer";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "choreographer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WjAE3UlUCiXK5DxwmZvehQQaoJRkgEE8rNJQdAyOM4Q=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Override chromium download & execute (borked on NixOS)
    sed -i '/def find_browser/,/) -> str | None:/ s#) -> str | None:#) -> str | None:\n        return "${lib.getExe ungoogled-chromium}"#' \
      src/choreographer/browsers/chromium.py

    # Override runtime libs check
    sed -i 's#"""Return true if libs ok."""#"""Return true if libs ok."""\n        _logger.debug("(nixpkgs) skipping lib check.")\n        return True#' \
      src/choreographer/browsers/chromium.py

    # Disable chromium crashpad
    sed -i 's#"--disable-breakpad"#"--disable-breakpad",\n                "--disable-crashpad-for-testing",\n                "--disable-gpu",\n                "--headless"#' \
      src/choreographer/browsers/chromium.py
  '';

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    logistro
    simplejson
  ];

  nativeCheckInputs = [
    pytestCheckHook

    # Undeclared but definitely needed
    pytest-asyncio
    async-timeout
    numpy
  ];

  pythonImportsCheck = [ "choreographer" ];

  pytestFlags = [ "--log-level=DEBUG" ];

  dontUsePytestCheck = stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Need a full graphical environment (we should add VM tests)
    "test_context"
    "test_no_context"
    "test_watchdog"

    # tests choreographer's own chrome download path, these fail since we've bypassed it
    "test_canary"
    "test_internal"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Devtools Protocol implementation for chrome";
    homepage = "https://github.com/plotly/choreographer";
    changelog = "https://github.com/plotly/choreographer/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      pandapip1
    ];
  };
})
