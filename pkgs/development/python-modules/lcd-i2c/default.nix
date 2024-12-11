{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
  smbus2,
}:

buildPythonPackage rec {
  pname = "lcd-i2c";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NYBaCXBmuTziT0WYEqrW10HRmRy3jpjH3YWQh5Y/TdQ=";
  };

  pythonRelaxDeps = [ "smbus2" ];

  build-system = [ poetry-core ];

  dependencies = [ smbus2 ];

  # Module has no tests
  doCheck = false;

  # Needs /dev/i2c-1
  # pythonImportsCheck = [ "lcd_i2c" ];

  meta = with lib; {
    description = "Library for interacting with an I2C LCD screen through Python";
    homepage = "https://pypi.org/project/lcd-i2c/";
    license = licenses.mit;
    maintainers = with maintainers; [ oliver-koss ];
    mainProgram = "lcd-i2c";
  };
}
