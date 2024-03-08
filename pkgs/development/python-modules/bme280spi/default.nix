{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, spidev
}:

buildPythonPackage rec {
  pname = "bme280spi";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51682acefda6f29eaaf9f37815edbfdd48ef0e9f1509419eceafe7b440eddc6e";
  };

  propagatedBuildInputs = [
    spidev
  ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Library for BME280 sensor through spidev";
    homepage = "https://github.com/Kuzj/bme280spi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
