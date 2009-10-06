{ stdenv, fetchurl, pkgconfig, dbus_glib, zlib, pam, glib, 
  libX11, policykit, expat, ... }:

stdenv.mkDerivation rec {
  name = "consolekit-0.2.10";
  
  src = fetchurl {
    url = http://www.freedesktop.org/software/ConsoleKit/dist/ConsoleKit-0.2.10.tar.gz;
    sha256 = "1jrv33shrmc1klwpgp02pycmbk9lfaxkd5q7bqxb6v95cl7m3f82";
  };
  
  buildInputs = [ pkgconfig dbus_glib zlib pam glib libX11 policykit expat ];

  configureFlags = "--enable-pam-module --with-pam-module-dir=$(out)/lib/security --localstatedir=/var --sysconfdir=/etc";

  # Needed for pthread_cancel().
  NIX_LDFLAGS = "-lgcc_s";

  installFlags = "sysconfdir=$(out)/etc DBUS_SYS_DIR=$(out)/etc/dbus-1/system.d"; # keep `make install' happy
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/ConsoleKit;
    description = "A framework for defining and tracking users, login sessions, and seats";
  };
}
