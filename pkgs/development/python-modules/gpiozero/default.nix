{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "Simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://github.com/gpiozero/gpiozero";
    changelog = "https://github.com/gpiozero/gpiozero/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
