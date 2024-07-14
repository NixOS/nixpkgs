{
  lib,
  buildPythonPackage,
  fetchPypi,
  smbus-cffi,
}:

buildPythonPackage rec {
  pname = "i2csense";
  version = "0.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b5wKN9lx5bimDFSYK9WAz/hL+U/twIwJfmA6jlYJwz8=";
  };

  propagatedBuildInputs = [ smbus-cffi ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "i2csense.bme280"
    "i2csense.bh1750"
    "i2csense.htu21d"
  ];

  meta = with lib; {
    description = "Library to handle i2c sensors with the Raspberry Pi";
    mainProgram = "i2csense";
    homepage = "https://github.com/azogue/i2csense";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
