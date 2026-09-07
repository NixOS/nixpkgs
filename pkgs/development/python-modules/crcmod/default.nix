{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crcmod";
  version = "1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07k0hgr42vw2j92cln3klxka81f33knd7459cn3d8aszvfh52w6w";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
    homepage = "https://crcmod.sourceforge.net/";
    license = lib.licenses.mit;
  };
}
