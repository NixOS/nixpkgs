{stdenv, fetchurl, pkgconfig, glib, libgsf, libxml2}:

stdenv.mkDerivation {
  name = "libwpd-0.8.3";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/libwpd/libwpd-0.8.3.tar.gz;
    md5 = "f34404f8dc6123aca156d203c37e3e5d";
  };
  buildInputs = [pkgconfig glib libgsf libxml2];
}
