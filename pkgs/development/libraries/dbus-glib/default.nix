args: with args;

stdenv.mkDerivation {
  name = "dbus-glib-0.74";
  src = fetchurl {
    url = http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.74.tar.gz;
    sha256 = "1qmbnd9xgg7vahlfywd8sfd9yqhx8jdyczz3cshfsd4qc76xhw78";
  };
  inherit dbus glib;
  buildInputs = [pkgconfig gettext glib expat];
  propagatedBuildInputs = [dbus];

  meta = {
	  homepage = http://dbus.freedesktop.org;
	  license = "AFL-2.1 or GPL-2";
	  description = "GLib bindings for D-Bus lightweight IPC mechanism";
  };
}
