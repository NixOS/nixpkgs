{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection, gnome3 }:

stdenv.mkDerivation rec {
  name = "rest-0.7.93";

  src = fetchurl {
    url = "mirror://gnome/sources/rest/0.7/${name}.tar.xz";
    sha256 = "05mj10hhiik23ai8w4wkk5vhsp7hcv24bih5q3fl82ilam268467";
  };

  buildInputs = [ pkgconfig glib libsoup gobjectIntrospection];

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
