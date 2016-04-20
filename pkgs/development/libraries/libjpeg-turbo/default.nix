{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "0gi349hp1x7mb98s4mf66sb2xay2kjjxj9ihrriw0yiy0k9va6sj";
  };

  outputs = [ "dev" "out" "doc" "bin" ];

  nativeBuildInputs = [ nasm ];

  enableParallelBuilding = true;

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

