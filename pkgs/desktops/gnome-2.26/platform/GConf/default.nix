{ stdenv, fetchurl, pkgconfig, dbus_glib, glib, gtk, ORBit2, libxml2
, expat, policykit, intltool}:

stdenv.mkDerivation {
  name = "GConf-2.26.2";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/GConf-2.26.2.tar.bz2;
    sha256 = "1vb7hjxddy54g4vch936621g66n0mhi3wkhm9lwqh449vdqg4yki";
  };
  buildInputs = [ pkgconfig glib gtk dbus_glib ORBit2 libxml2
                  expat policykit intltool ];
}
