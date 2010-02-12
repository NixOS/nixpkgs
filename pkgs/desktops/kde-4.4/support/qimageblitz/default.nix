{stdenv, fetchurl, lib, cmake, qt4}:

stdenv.mkDerivation {
  name = "qimageblitz-0.0.4";
  src = fetchurl {
    url = mirror://sourceforge/qimageblitz/qimageblitz-0.0.4.tar.bz2;
    md5 = "cb87c7f1c0455e8984ee4830f1e749cf";
  };
  buildInputs = [ cmake qt4 ];
  meta = {
    description = "Graphical effect and filter library for KDE4";
    license = "BSD";
    homepage = http://qimageblitz.sourceforge.net;
    maintainers = [ lib.maintainers.sander ];
  };
}
