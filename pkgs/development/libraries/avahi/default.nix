{stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation {
  name = "avahi-0.6.11";
  src = fetchurl {
    url = http://avahi.org/download/avahi-0.6.11.tar.gz;
    md5 = "91fd8cc0c2bae638848faad36cf1c032";
  };

  #buildInputs = [pkgconfig glib gtk libpng libglade];
  buildInputs = [pkgconfig];

  configureFlags = "--disable-glib --disable-qt3 --disable-qt4 --disable-gtk --disable-dbus --disable-expat --disable-gdbm --disable-libdaemon --disable-python --disable-mono";
}
