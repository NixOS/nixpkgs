{stdenv, fetchurl, xlibsWrapper, imake, gccmakedep, libXmu, libXpm, libXp, bison, flex, pkgconfig}:

stdenv.mkDerivation {
  name = "Xaw3d-1.6.2";
  src = fetchurl {
    urls = [ 
      ftp://ftp.x.org/pub/xorg/individual/lib/libXaw3d-1.6.tar.bz2
      ];
    sha256 = "099kx6ni5vkgr3kf40glif8m6r1m1hq6hxqlqrblaj1w5cphh8hi";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [imake gccmakedep libXpm libXp bison flex];
  propagatedBuildInputs = [xlibsWrapper libXmu];

  meta = {
    description = "3D widget set based on the Athena Widget set";
    platforms = stdenv.lib.platforms.linux;
  };
}
