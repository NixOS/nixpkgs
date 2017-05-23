{ stdenv, fetchurl, pkgconfig, cmake
, nssmdns, avahi, tde }:

let baseName = "avahi-tqt"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "179cd6c85v7h7m7dz0rm4n4jmqrqsi2n1ylgaaqps3gr8fm0w2z6";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ nssmdns avahi tde.tqtinterface ];

  preConfigure = ''
    cd ${baseName}
  '';

  meta = with stdenv.lib;{
    description = "Avahi TQt bindings";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
