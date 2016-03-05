{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.11.1"; # CLooG 0.16.3 fails to build with ISL 0.08.

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/gcc/isl-0.11.1.tar.bz2/bce1586384d8635a76d2f017fb067cd2/isl-0.11.1.tar.bz2";
    sha256 = "13d9cqa5rzhbjq0xf0b2dyxag7pqa72xj9dhsa03m8ccr1a4npq9";
  };

  buildInputs = [ gmp ];
  patches = [ ./fix-gcc-build.diff ];

  enableParallelBuilding = true;

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  meta = {
    homepage = http://www.kotnet.org/~skimo/isl/;
    license = stdenv.lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = stdenv.lib.platforms.all;
  };
}
