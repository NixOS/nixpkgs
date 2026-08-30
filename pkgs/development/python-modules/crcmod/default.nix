{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "crcmod";
  version = "1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3HBRoNtfK9SGZamQ0+wcwwWkZqdzWMpEkoJvQfKDYB4=";
  };

  meta = {
    description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
    homepage = "https://crcmod.sourceforge.net/";
    license = lib.licenses.mit;
  };
}
