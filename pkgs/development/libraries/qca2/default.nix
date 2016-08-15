{ stdenv, fetchurl, cmake, pkgconfig, qt }:

stdenv.mkDerivation rec {
  name = "qca-2.1.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/2.1.1/src/qca-2.1.1.tar.xz";
    sha256 = "10z9icq28fww4qbzwra8d9z55ywbv74qk68nhiqfrydm21wkxplm";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qt ];

  enableParallelBuilding = true;

  patches = [ ./libressl.patch ];

  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
