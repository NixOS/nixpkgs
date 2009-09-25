{ stdenv, fetchurl, pkgconfig, dbus_glib, zlib, pam, glib, libX11, polkit }:

stdenv.mkDerivation rec {
  name = "console-kit-0.3.1";
  
  src = fetchurl {
    url = http://www.freedesktop.org/software/ConsoleKit/dist/ConsoleKit-0.3.1.tar.bz2;
    sha256 = "0b834ly6l8l76awr2pn2xz3ic6ilhfif4h3nsi96ffa91n09ydk0";
  };
  
  buildInputs = [ pkgconfig dbus_glib zlib pam glib libX11 polkit ];

  configureFlags = "--enable-pam-module --with-pam-module-dir=$(out)/lib/security --localstatedir=/var --sysconfdir=/etc";

  # Needed for pthread_cancel().
  NIX_LDFLAGS = "-lgcc_s";

  installFlags = "sysconfdir=$(out)/etc DBUS_SYS_DIR=$(out)/etc/dbus-1/system.d"; # keep `make install' happy
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/ConsoleKit;
    description = "A framework for defining and tracking users, login sessions, and seats";
  };
}
