{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  smbus2,

  # checks
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bme680";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimoroni";
    repo = "bme680-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ep0dnok/ycEoUAnOK4QmdqdO0r4ttzSoqHDl7aPengE=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [ smbus2 ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bme680" ];

  meta = with lib; {
    description = "Python library for driving the Pimoroni BME680 Breakout";
    homepage = "https://github.com/pimoroni/bme680-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
  };
}
