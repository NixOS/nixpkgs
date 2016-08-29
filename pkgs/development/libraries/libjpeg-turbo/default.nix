{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "0pq3lav976d6a1d16yyqrj1b4gmhk1ca4zar6zp00avxlqqpqfcz";
  };

  patches =
    stdenv.lib.optional (stdenv.cross.libc or null == "msvcrt")
      ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "out" "doc" ];

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

