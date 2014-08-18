{ stdenv, fetchurl, python, pkgconfig, dbus, dbus_glib, dbus_tools }:

stdenv.mkDerivation rec {
  name = "dbus-python-1.2.0";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-python/${name}.tar.gz";
    sha256 = "1py62qir966lvdkngg0v8k1khsqxwk5m4s8nflpk1agk5f5nqb71";
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
