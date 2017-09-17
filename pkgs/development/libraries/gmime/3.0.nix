{ stdenv, fetchurl, pkgconfig, glib, gpgme, zlib, libgpgerror, libidn, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gmime-3.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.0/${name}.tar.xz";
    sha256 = "001y93b8mq9alzkvli6vfh3pzdcn5c5iy206ml23lzhhhvm5k162";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib gpgme zlib libgpgerror libidn gobjectIntrospection
  ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--enable-introspection=yes" ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://github.com/jstedfast/gmime/;
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.unix;
  };
}
