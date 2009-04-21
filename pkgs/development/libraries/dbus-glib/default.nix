args: with args;

stdenv.mkDerivation rec {
  name = "dbus-glib-0.74";
  
  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "1qmbnd9xgg7vahlfywd8sfd9yqhx8jdyczz3cshfsd4qc76xhw78";
  };
  
  buildInputs = [pkgconfig expat gettext];
  
  propagatedBuildInputs = [dbus.libs glib];
  
  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = "AFL-2.1 or GPL-2";
    description = "GLib bindings for D-Bus lightweight IPC mechanism";
  };
}
