{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pythonOlder,
  setuptools,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "pyflipper";
  version = "0.18-unstable-2024-04-15";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "wh00hw";
    repo = "pyFlipper";
    # https://github.com/wh00hw/pyFlipper/issues/20
    rev = "e8a82a25eb766fac53a2e6e5fff6505f60cf0897";
    hash = "sha256-CQ6oVVkLxyoNoe7L0USfal1980VkfiuHc4cqXTsZ2Jc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    websocket-client
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflipper" ];

  meta = {
    description = "Flipper Zero Python CLI Wrapper";
    homepage = "https://github.com/wh00hw/pyFlipper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
