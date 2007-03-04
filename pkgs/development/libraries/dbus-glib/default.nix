{stdenv, fetchurl, pkgconfig, gettext, dbus, glib, expat}:

stdenv.mkDerivation {
  name = "dbus-glib-0.73";
  src = fetchurl {
    url = http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.73.tar.gz;
    sha256 = "14ndjhbn6q4m7wrml8s57wghnjbm6a6fqb5jgazjxcn6748gkmyn";
  };
  inherit dbus glib;
  buildInputs = [pkgconfig gettext glib expat];
  propagatedBuildInputs = [dbus];
}
