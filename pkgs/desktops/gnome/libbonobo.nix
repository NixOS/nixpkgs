{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, dbus, dbus_glib, ORBit2, libxml2
, popt, yacc, flex, gettext, intltool }:

assert pkgconfig != null && perl != null && ORBit2 != null
  && libxml2 != null && popt != null && yacc != null && flex != null;

# todo 2.8.1 doesn;t work
stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl perlXMLParser libxml2 yacc flex
    dbus dbus_glib
    gettext intltool
  ];
  propagatedBuildInputs = [ORBit2 popt];
}
