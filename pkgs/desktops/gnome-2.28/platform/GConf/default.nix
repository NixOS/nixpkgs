{ stdenv, fetchurl, pkgconfig, dbus_glib, glib, gtk, ORBit2, libxml2
, expat, policykit, intltool, dbus_libs}:

stdenv.mkDerivation {
  name = "GConf-2.26.2";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/GConf-2.26.2.tar.bz2;
    sha256 = "1vb7hjxddy54g4vch936621g66n0mhi3wkhm9lwqh449vdqg4yki";
  };

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${dbus_glib}/include/dbus-1.0 -I${policykit}/include/PolicyKit -I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${dbus_libs}/include/dbus-1.0 -I${dbus_libs}/lib/dbus-1.0/include"
    export NIX_LDFLAGS="$NIX_LDFLAGS $(glib-config --libs)"
  '';

  buildInputs = [ pkgconfig glib gtk dbus_glib ORBit2 libxml2
                  expat policykit intltool dbus_libs];
}
