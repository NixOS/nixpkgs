{stdenv, fetchurl, pkgconfig, libX11, libICE}:

derivation {
  name = "libSM-6.0.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/libSM-6.0.2.tar.bz2;
    md5 = "0ecc3ec75391d9158f25a94a652bd387";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libICE];
  inherit stdenv;
}
