{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "027vz97064bjmwj7gdw2p47y1437w08j54frpgzmnql5rvabmxab";
  };

  buildInputs = [ nasm ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    maintainers = [ maintainers.vcunat ];
    # upstream supports darwin (and others), but it doesn't build currently
    platforms = platforms.all;
    hydraPlatforms = platforms.linux;
  };
}

