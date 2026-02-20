{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  appdirs,
  intelhex,
  pyedbglib,
  pyserial,
  pyyaml,

  # tests
  mock,
  parameterized,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  pname = "pymcuprog";
  version = "3.19.4.61";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microchip-pic-avr-tools";
    repo = "pymcuprog";
    # the repo currently does not tag releases, so using the
    # commit ID for now
    rev = "e2fa9a7f0b9cc413367c51b9ccf19d93cdca6c8";
    hash = "sha256-RmFGQ6LbuwwM/WHr01nYGZYoWG7Qbasz/TL4r8l1NUk";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    appdirs
    intelhex
    pyedbglib
    pyserial
    pyyaml
  ];

  pythonImportsCheck = [ "pymcuprog" ];

  nativeCheckInputs = [
    mock
    parameterized
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = "HOME";

  meta = {
    description = "Python utility for programming various Microchip MCU devices using Microchip CMSIS-DAP based debuggers";
    mainProgram = "pymcuprog";
    homepage = "https://github.com/microchip-pic-avr-tools/pymcuprog";
    changelog = "https://github.com/microchip-pic-avr-tools/pymcuprog/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prophetofxenu ];
  };
}
