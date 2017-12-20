{ stdenv, fetchurl, nasm
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-${version}";
  version = "1.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "08r5b5mywwrxv4axvq80dm31cklz81grczlzlxr2xqa6pgi90j5j";
  }; # github releases still need autotools, surprisingly

  patches =
    stdenv.lib.optional (hostPlatform.libc or null == "msvcrt")
      ./mingw-boolean.patch;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ nasm ];

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;
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

