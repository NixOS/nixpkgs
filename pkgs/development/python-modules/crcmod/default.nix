{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "crcmod";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07k0hgr42vw2j92cln3klxka81f33knd7459cn3d8aszvfh52w6w";
  };

  meta = with stdenv.lib; {
    description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
    homepage = http://crcmod.sourceforge.net/;
    license = licenses.mit;
  };
}
