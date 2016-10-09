{ stdenv, fetchurl, pkgconfig, cmake
, nssmdns, avahi, tde }:

stdenv.mkDerivation rec{

  name = "avahi-tqt-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14";
  minorVer = "0.3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "1g56mcjg6pqhlljxj6m1b0iv7jg7s22fqjl36r0i7bkgdxz8lbwm";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ nssmdns avahi tde.tqtinterface ];

  preConfigure = ''
    cd avahi-tqt
  '';

  meta = with stdenv.lib;{
    description = "Avahi TQt bindings";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
