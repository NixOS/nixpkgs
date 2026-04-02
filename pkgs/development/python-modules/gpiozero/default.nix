{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # docs
  sphinx-rtd-theme,
  sphinxHook,

  # dependencies
  colorzero,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "gpiozero";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpiozero";
    repo = "gpiozero";
    tag = "v${version}";
    hash = "sha256-ifdCFcMH6SrhKQK/TJJ5lJafSfAUzd6ZT5ANUzJGwxI=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    setuptools
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [ colorzero ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "gpiozero"
    "gpiozero.tools"
  ];

  disabledTests = [
    # https://github.com/gpiozero/gpiozero/issues/1087
    "test_spi_hardware_write"
  ];

  meta = {
    description = "Simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://github.com/gpiozero/gpiozero";
    changelog = "https://github.com/gpiozero/gpiozero/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
