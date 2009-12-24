{stdenv, fetchurl, lib, which, qt4}:

stdenv.mkDerivation {
  name = "qca-2.0.2";
  src = fetchurl {
    url = http://delta.affinix.com/download/qca/2.0/qca-2.0.2.tar.bz2;
    sha256 = "49b5474450104a2298747c243de1451ab7a6aeed4bf7df43ffa4b7128a2837b8";
  };
  buildInputs = [ which qt4 ];
  meta = {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ lib.maintainers.sander ];
  };
}
