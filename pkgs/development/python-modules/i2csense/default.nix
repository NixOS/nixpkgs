{ lib
, buildPythonPackage
, fetchPypi
, smbus-cffi
}:

buildPythonPackage rec {
  pname = "i2csense";
  version = "0.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f9c0a37d971e5b8a60c54982bd580cff84bf94fedc08c097e603a8e5609c33f";
  };

  propagatedBuildInputs = [
    smbus-cffi
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "i2csense.bme280"
    "i2csense.bh1750"
    "i2csense.htu21d"
  ];

  meta = with lib; {
    description = "A library to handle i2c sensors with the Raspberry Pi";
    homepage = "https://github.com/azogue/i2csense";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
