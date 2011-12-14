{ stdenv, fetchurl, pkgconfig, expat, gettext, libiconv, dbus, glib }:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.98";

  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "04fiwld5yaxyggxlvdmbaqkngh4fn8gfkkqckcp3274bpgb82z19";
  };
  
  buildInputs = [ pkgconfig expat gettext ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;
  
  propagatedBuildInputs = [ dbus.libs glib ];
  
  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = "AFL-2.1 or GPL-2";
    description = "GLib bindings for D-Bus lightweight IPC mechanism";
  };
}
