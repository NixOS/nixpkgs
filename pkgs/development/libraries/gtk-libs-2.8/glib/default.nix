{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.10.3";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/glib/2.10/glib-2.10.3.tar.bz2;
    md5 = "87206e721c12d185d17dd9ecd7e30369";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [gettext];
}
