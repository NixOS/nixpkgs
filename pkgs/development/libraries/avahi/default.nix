{stdenv, fetchurl, pkgconfig, libdaemon, dbus}:

stdenv.mkDerivation {
  name = "avahi-0.6.21";
  src = fetchurl {
    url = http://avahi.org/download/avahi-0.6.21.tar.gz;
    sha256 = "d817c35f43011861476eab02eea14edd123b2bc58b4408d9d9b69b0c39252561";
  };

  #buildInputs = [pkgconfig glib gtk libpng libglade];
  buildInputs = [pkgconfig libdaemon dbus];

  configureFlags = "--disable-glib --disable-qt3 --disable-qt4 --disable-gtk --disable-expat --disable-gdbm --disable-python --disable-mono --with-distro=none CPPFLAGS=-Ddbus_watch_get_unix_fd=dbus_watch_get_fd";
}
