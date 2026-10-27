{
  lib,
  buildPythonPackage,
  fetchurl,
}:

buildPythonPackage {
  pname = "pynac";
  version = "0.2";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://sourceforge/project/pynac/pynac/pynac-0.2/pynac-0.2.tar.gz";
    hash = "sha256-t78ntAcElq5z5VB1aobaFaUWvV4yKVplVpMU2hnGfys=";
  };

  meta = {
    homepage = "https://github.com/se-esss-litterbox/Pynac";
    description = "Python wrapper around the Dynac charged particle simulator";
    license = lib.licenses.gpl3;
  };
}
