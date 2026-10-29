{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyftdi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyi2cflash";
  version = "0.2.2";

  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "pyi2cflash";
    inherit (finalAttrs) version;
    hash = "sha256-oVPKm+SNQABZeXnhPjW5ztNwXBPe5VK9PF+qe9z7ato=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyftdi ];

  # tests are not shipped with the PyPI source
  # and require ftdi connection that cannot be reproduced in sandbox
  doCheck = false;

  pythonImportsCheck = [ "i2cflash" ];

  meta = {
    description = "I2C eeprom device drivers in Python";
    homepage = "https://github.com/eblot/pyi2cflash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
