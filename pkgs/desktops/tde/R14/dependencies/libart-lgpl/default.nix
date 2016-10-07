{ stdenv, fetchurl, pkgconfig }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "libart-lgpl-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14.0";
  minorVer = "3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "0gnzdml05ggc95cv069in72glagmn98bs10lyhmvh8k1snxqdj6h";
  };

  buildInputs = [ pkgconfig ];

  configureFlags = ''
    --enable-ansi
  '';

  preConfigure = ''
    cd libart-lgpl
  '';

  meta = with stdenv.lib;{
    description = "A 2D drawing library";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# Warning: autotool build, will be deprecated by cmake in the future
