{ stdenv, fetchurl, nasm
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "0v365hm6z6lddcqagjj15wflk66rqyw75m73cqzl65rh4lyrshj1";
  }; # github releases still need autotools, surprisingly

  patches =
    stdenv.lib.optional (hostPlatform.libc or null == "msvcrt")
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

