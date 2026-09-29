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
  version = "2.0.1.post3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpiozero";
    repo = "gpiozero";
    tag = "v${version}";
    hash = "sha256-8NSGR+GLnf+7F9iu0XVK/yVYVw8L9b73FIs07OSvMj4=";
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
