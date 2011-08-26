{ stdenv, fetchurl, pkgconfig, expat, gettext, libiconv, dbus, glib }:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.94";

  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "16yk106bp58in6vz2li2s3iwk1si65f0n22m8c2mplzh2j9zlq74";
  };

  buildInputs = [ pkgconfig expat gettext ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;

  propagatedBuildInputs = [ dbus glib ];

  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = "AFL-2.1 or GPL-2";
    description = "GLib bindings for D-Bus lightweight IPC mechanism";
  };
}
