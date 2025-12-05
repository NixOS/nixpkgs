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
  version = "0.21";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "wh00hw";
    repo = "pyFlipper";
    tag = "v${version}";
    hash = "sha256-IMd9RzGblfsyDH4TC+ip5a2zx4gzXbzjIaWMldEy5xk=";
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
    changelog = "https://github.com/wh00hw/pyFlipper/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
