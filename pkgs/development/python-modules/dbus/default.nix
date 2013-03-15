{ stdenv, fetchurl, python, pkgconfig, dbus, dbus_glib, dbus_tools }:

stdenv.mkDerivation rec {
  name = "dbus-python-1.1.1";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-python/${name}.tar.gz";
    sha256 = "122yj5y0mndk9axh735qvwwckck6s6x0q84dw6p97mplp17wl5w9";
  };

  postPatch = "patchShebangs .";

  buildInputs = [ python pkgconfig dbus dbus_glib ]
    ++ stdenv.lib.optional doCheck dbus_tools;

  doCheck = false; # https://bugs.freedesktop.org/show_bug.cgi?id=57140

  meta = {
    description = "Python DBus bindings";
    license = "MIT";
  };
}
