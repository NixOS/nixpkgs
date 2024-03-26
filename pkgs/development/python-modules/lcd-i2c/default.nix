{ lib
, python3
, fetchPypi
, buildPythonPackage
, smbus2
, poetry-core
}:

buildPythonPackage rec {
  pname = "lcd-i2c";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NYBaCXBmuTziT0WYEqrW10HRmRy3jpjH3YWQh5Y/TdQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    smbus2
  ];

  meta = with lib; {
    description = "Library for interacting with an I2C LCD screen through Python";
    homepage = "https://pypi.org/project/lcd-i2c/";
    license = licenses.mit;
    maintainers = with maintainers; [ oliver-koss ];
    mainProgram = "lcd-i2c";
  };
}
