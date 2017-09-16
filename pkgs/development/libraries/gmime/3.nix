{ stdenv, fetchurl, pkgconfig, glib, zlib, gpgme, libidn, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "3.0.1";
  name = "gmime-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.0/${name}.tar.xz";
    sha256 = "001y93b8mq9alzkvli6vfh3pzdcn5c5iy206ml23lzhhhvm5k162";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  propagatedBuildInputs = [ glib zlib gpgme libidn ];
  configureFlags = [ "--enable-introspection=yes" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jstedfast/gmime/;
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chaoflow ];
    platforms = platforms.unix;
  };
}
