{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  websocket-client,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyflipper";
  version = "0.18-unstable-2024-04-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wh00hw";
    repo = "pyFlipper";
    rev = "e8a82a25eb766fac53a2e6e5fff6505f60cf0897";
    hash = "sha256-CQ6oVVkLxyoNoe7L0USfal1980VkfiuHc4cqXTsZ2Jc=";
  };

  build-system = [ setuptools ];
  dependencies = [ pyserial websocket-client ];

  pythonImportsCheck = [
    "pyflipper"
  ];

  meta = with lib; {
    description = "Flipper Zero Python CLI Wrapper";
    homepage = "https://github.com/wh00hw/pyFlipper";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
