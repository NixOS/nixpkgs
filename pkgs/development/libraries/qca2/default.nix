{ stdenv, fetchurl, cmake, pkgconfig, qt }:

stdenv.mkDerivation rec {
  name = "qca-2.1.0";

  src = fetchurl {
    url = "http://delta.affinix.com/download/qca/2.0/${name}.tar.gz";
    sha256 = "114jg97fmg1rb4llfg7x7r68lxdkjrx60qsqq76khdwc2dvcsv92";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qt ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.sander maintainers.urkud ];
  };
}
