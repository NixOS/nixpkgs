{ stdenv, fetchurl, pkgconfig, perl, glib, gnomevfs, libbonobo
, GConf, popt, zlib }:

assert pkgconfig != null && perl != null && glib != null
  && gnomevfs != null && libbonobo != null && GConf != null
  && popt != null && zlib != null;

# !!! TO CHECK:
# libgnome tries to install stuff into GConf (which fails):
# "WARNING: failed to install schema `/schemas/desktop/gnome/url-handlers/https/need-terminal' locale `is': Failed:
# Failed to create file `/nix/store/14d4fc76451786eba9dea087d56dc719-GConf-2.4.0/etc/gconf/gconf.xml.defaults/%gconf.xml': Permission denied"

stdenv.mkDerivation {
  name = "libgnome-2.0.6";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libgnome-2.4.0.tar.bz2;
    md5 = "caec1e12d64b98a2925a4317ac16429f";
  };
  buildInputs = [pkgconfig perl popt zlib];
  propagatedBuildInputs = [glib gnomevfs libbonobo GConf];
}
