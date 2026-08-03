{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyftdi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyi2cflash";
  version = "0.2.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nkazgf7pajz7jym5rfy2df71lyfp4skxqbrg5ch0h4dwjdwllx1";
  };

  build-system = [ setuptools ];

  dependencies = [ pyftdi ];

  # tests are not shipped with the PyPI source
  doCheck = false;

  pythonImportsCheck = [ "i2cflash" ];

  meta = {
    description = "I2C eeprom device drivers in Python";
    homepage = "https://github.com/eblot/pyi2cflash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
