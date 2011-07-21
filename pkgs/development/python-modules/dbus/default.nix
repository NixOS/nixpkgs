{ stdenv, fetchurl, python, pkgconfig, dbus, dbus_glib }:

stdenv.mkDerivation rec {
  name = "dbus-python-0.84.0";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-python/${name}.tar.gz";
    sha256 = "01jrmj7ps79dkd6f8bzm17vxzpad1ixwmcb1liy64xm9y6mcfnxq";
  };

  buildInputs = [ python pkgconfig dbus dbus_glib ];

  meta = {
    description = "Python DBus bindings";
  };
}
