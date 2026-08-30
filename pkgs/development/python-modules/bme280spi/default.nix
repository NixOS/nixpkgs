{
  lib,
  buildPythonPackage,
  fetchPypi,
  spidev,
}:

buildPythonPackage rec {
  pname = "bme280spi";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UWgqzv2m8p6q+fN4Fe2/3UjvDp8VCUGezq/ntEDt3G4=";
  };

  propagatedBuildInputs = [ spidev ];

  # no tests implemented
  doCheck = false;

  meta = {
    description = "Library for BME280 sensor through spidev";
    mainProgram = "bme280spi";
    homepage = "https://github.com/Kuzj/bme280spi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
