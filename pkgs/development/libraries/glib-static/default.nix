{ stdenv, fetchurl, pkgconfig, gettext, perl
, enableStatic ? false
}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.10.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glib-2.10.3.tar.bz2;
    md5 = "87206e721c12d185d17dd9ecd7e30369";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [gettext];
  configureFlags = "${if enableStatic then "--enable-static" else ""}";
  inherit enableStatic;
}
