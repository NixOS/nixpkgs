{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, popt, zlib, esound, gettext, intltool
}:

# !!! TODO CHECK:
# libgnome tries to install stuff into GConf (which fails):
# "WARNING: failed to install schema `/schemas/desktop/gnome/url-handlers/https/need-terminal' locale `is': Failed:
# Failed to create file `/nix/store/14d4fc76451786eba9dea087d56dc719-GConf-2.4.0/etc/gconf/gconf.xml.defaults/%gconf.xml': Permission denied"

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl perlXMLParser popt zlib esound gettext intltool];
  propagatedBuildInputs = [gnome.glib gnome.gnomevfs gnome.libbonobo gnome.GConf];
}
