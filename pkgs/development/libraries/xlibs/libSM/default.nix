{stdenv, fetchurl, pkgconfig, libX11, libICE}:

stdenv.mkDerivation {
  name = "libSM-6.0.3";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/libSM-6.0.3.tar.bz2;
    md5 = "e01ec6568ad17c5df8f56828e34a0b2b";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libICE];
}
