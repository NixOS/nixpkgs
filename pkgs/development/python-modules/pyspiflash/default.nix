{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyftdi,
}:

buildPythonPackage rec {
  pname = "pyspiflash";
  version = "0.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7FaGfU71DgJITVxHKJivWSR1t+F4JKcGWFpbUnHg1kU=";
  };

  propagatedBuildInputs = [ pyftdi ];

  # tests are not shipped with the PyPI source
  doCheck = false;

  pythonImportsCheck = [ "spiflash" ];

  meta = with lib; {
    description = "SPI data flash device drivers in Python";
    homepage = "https://github.com/eblot/pyspiflash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
