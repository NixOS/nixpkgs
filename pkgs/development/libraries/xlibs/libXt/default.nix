{stdenv, fetchurl, pkgconfig, libX11, libSM}:

stdenv.mkDerivation {
  name = "libXt-0.1.5";
  src = fetchurl {
    url = http://xlibs.freedesktop.org/release/libXt-0.1.5.tar.bz2;
    md5 = "8ff20498eeedebe2fb72f93c2d7beab1";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libSM];
}
