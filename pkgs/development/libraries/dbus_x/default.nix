args: with args;

stdenv.mkDerivation {
  name = "dbus-1.0.2";
  src = fetchurl {
    url = http://dbus.freedesktop.org/releases/dbus/dbus-1.0.2.tar.gz;
    sha256 = "1jn652zb81mczsx4rdcwrrzj3lfhx9d107zjfnasc4l5yljl204a";
  };
  buildInputs = [pkgconfig expat libX11 libICE libSM];

  configureFlags = "--with-x --disable-static --localstatedir=/var --with-session-socket-dir=/tmp";
  patchPhase = "sed -e /mkinstalldirs.*localstatedir/d -i bus/Makefile.in";
}
