{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyserial,
}:

buildPythonPackage rec {
  pname = "modbus-tk";
  version = "1.1.5";
  pyproject = true;

  src = fetchPypi {
    pname = "modbus_tk";
    inherit version;
    hash = "sha256-d6cqOtnV0yodIRC8BCFmgMpX11IpEuDycem/XxtwGzY=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  # Source no tagged anymore and PyPI doesn't ship tests
  doCheck = false;

  pythonImportsCheck = [ "modbus_tk" ];

  meta = {
    description = "Module for simple Modbus interactions";
    homepage = "https://github.com/ljean/modbus-tk";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
