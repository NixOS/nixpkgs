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
    sha256 = "0avzqqcxl54karjmla9jbsyid98mva36lxahwmrsx5h40ys2ggxp";
  };

  meta = {
    homepage = "https://github.com/se-esss-litterbox/Pynac";
    description = "Python wrapper around the Dynac charged particle simulator";
    license = lib.licenses.gpl3;
  };
}
