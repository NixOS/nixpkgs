{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  selenium,
  firefox,
  geckodriver,
  psutil,
  pytestCheckHook,
  which,
  writableTmpDirAsHomeHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "helium";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "helium";
    tag = "v${version}";
    hash = "sha256-SGLxP2OOzosLpZn/DgIJN3BnbUeg8cXE1HhKBF4EpyM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    selenium
  ];

  nativeCheckInputs = [
    firefox
    geckodriver
    psutil
    pytestCheckHook
    which
    writableTmpDirAsHomeHook
  ];

  # helium doesn't support testing on all platforms
  doCheck = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);

  # Selenium setup
  preCheck = ''
    export TEST_BROWSER=firefox
    export SE_OFFLINE=true
  '';

  disabledTestPaths = [
    # All of the tests here fail, maybe because we force a driver to be found via envvars?
    "tests/api/test_no_driver.py"

    # New tests, not sure why they fail. Maybe due to forced firefox?
    "tests/api/test_write.py"
  ];

  pythonImportsCheck = [
    "helium"
  ];

  meta = {
    description = "Lighter web automation with Python";
    homepage = "https://github.com/mherrmann/helium";
    changelog = "https://github.com/mherrmann/helium/releases/tag/v${version}";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
  };
}
