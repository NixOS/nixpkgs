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
    sha256 = "0ifnw1qm4nssb03af93qw6vpa92rmyc2hisw9m4043pm9ryqcmpc";
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
