sha256: args: with args;

stdenv.mkDerivation rec {
  name = "avahi-" + version;
  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    inherit sha256;
  };

  buildInputs = [pkgconfig libdaemon dbus perl perlXMLParser glib qt4];

  configureFlags = "--disable-qt3 --disable-gdbm --disable-gtk --disable-mono
    --with-distro=none --enable-shared --disable-static --disable-python";

  meta = {
    homepage = http://avahi.org;
  };
}
