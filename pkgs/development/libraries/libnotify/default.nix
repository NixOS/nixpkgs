args: with args;
 
stdenv.mkDerivation {
  name = "libnotify-0.4.4";
  #builder = ./builder.sh;

  src = fetchurl {
    url = http://www.galago-project.org/files/releases/source/libnotify/libnotify-0.4.4.tar.gz;
    sha256 = "2389a9b8220f776033f728a8d46352cfee5c8705066e34887bfb188f9f0d3856";
  };

  buildInputs = [
    pkgconfig dbus.libs dbus_glib gtk glib
  ];

  configureFlags="";
}
