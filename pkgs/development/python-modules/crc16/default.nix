{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "crc16";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15nkx0pa4lskwin84flpk8fsw3jqg6wic6v3s83syjqg76h6my61";
  };

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/pycrc16/";
    description = "Python library for calculating CRC16";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
