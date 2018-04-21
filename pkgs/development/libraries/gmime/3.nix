{ stdenv, fetchurl, pkgconfig, glib, zlib, gpgme, libidn, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "3.0.5";
  name = "gmime-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/3.0/${name}.tar.xz";
    sha256 = "1q45gd1ahnz9q1milc2lqqwl7j3q0wd6kiswhp25iak222n56lrg";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ gobjectIntrospection zlib gpgme libidn ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib ];
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
