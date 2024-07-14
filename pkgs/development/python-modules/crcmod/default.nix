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

  meta = with lib; {
    description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
    homepage = "https://crcmod.sourceforge.net/";
    license = licenses.mit;
  };
}
