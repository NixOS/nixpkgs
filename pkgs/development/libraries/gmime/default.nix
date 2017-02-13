{ stdenv, fetchurl, pkgconfig, glib, zlib, libgpgerror, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gmime-2.6.23";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${name}.tar.xz";
    sha256 = "0slzlzcr3h8jikpz5a5amqd0csqh2m40gdk910ws2hnaf5m6hjbi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  propagatedBuildInputs = [ glib zlib libgpgerror ];
  configureFlags = [ "--enable-introspection=yes" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.unix;
  };
}
