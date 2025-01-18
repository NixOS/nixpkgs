{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  pyserial,
}:

buildPythonPackage rec {
  pname = "modbus-tk";
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "modbus_tk";
    inherit version;
    hash = "sha256-aJd3ZusQRplz3VaigUvZgbhd0YC3kEMkh4bYgAjyWTs=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  # Source no tagged anymore and PyPI doesn't ship tests
  doCheck = false;

  pythonImportsCheck = [ "modbus_tk" ];

  meta = with lib; {
    description = "Module for simple Modbus interactions";
    homepage = "https://github.com/ljean/modbus-tk";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
  };
}
