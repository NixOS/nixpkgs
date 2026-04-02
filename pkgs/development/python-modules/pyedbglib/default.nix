{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  cython,
  hidapi,
  pyserial,

  # tests
  pytestCheckHook,
  mock,
}:

buildPythonPackage {
  pname = "pyedbglib";
  version = "2.24.2.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microchip-pic-avr-tools";
    repo = "pyedbglib";
    # the repo currently does not tag releases, so using the
    # commit ID for now
    rev = "9bbeceba942772ef31b9c059b761460a782313e";
    hash = "sha256-iZB/+JEBy5n1zfajmJmEqRVQ2hPzJD/U85SvmyFiGhc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cython
    hidapi
    pyserial
  ];

  pythonImportsCheck = [ "pyedbglib" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = {
    description = "Low-level protocol library for communicating with Microchip CMSIS-DAP based debuggers";
    homepage = "https://github.com/microchip-pic-avr-tools/pyedbglib";
    changelog = "https://github.com/microchip-pic-avr-tools/pyedbglib/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prophetofxenu ];
  };
}
