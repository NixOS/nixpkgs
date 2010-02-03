args: with args;

stdenv.mkDerivation rec {
  name = "dbus-glib-0.80";
  
  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "0nv4gxcbpa9f0907dmzmfm222w8y45z19cx27l85f5qknf8hncxm";
  };
  
  buildInputs = [pkgconfig expat gettext libiconv];
  
  propagatedBuildInputs = [dbus.libs glib];
  
  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = "AFL-2.1 or GPL-2";
    description = "GLib bindings for D-Bus lightweight IPC mechanism";
  };
}
