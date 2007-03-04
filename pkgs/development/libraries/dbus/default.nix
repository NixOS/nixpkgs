{stdenv, fetchurl, pkgconfig, expat}:

stdenv.mkDerivation {
  name = "dbus-1.0.2";
  src = fetchurl {
    url = http://dbus.freedesktop.org/releases/dbus/dbus-1.0.2.tar.gz;
    sha256 = "1jn652zb81mczsx4rdcwrrzj3lfhx9d107zjfnasc4l5yljl204a";
  };
  buildInputs = [pkgconfig expat];
  #configureFlags = "--localstatedir=/var";
}
