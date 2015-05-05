{ stdenv, fetchurl, pkgconfig, libxml2, swig2, python, glib }:

stdenv.mkDerivation rec {
  name = "libplist-1.12";

  nativeBuildInputs = [ pkgconfig swig2 ];

  #patches = [ ./swig.patch ];

  propagatedBuildInputs = [ libxml2 glib python ];

  passthru.swig = swig2;

  src = fetchurl {
    url = "http://www.libimobiledevice.org/downloads/${name}.tar.bz2";
    sha256 = "1gj4nv0bvdm5y2sqm2vj2rn44k67ahw3mh6q614qq4nyngfdxzqf";
  };

  meta = {
    homepage = http://github.com/JonathanBeck/libplist;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
