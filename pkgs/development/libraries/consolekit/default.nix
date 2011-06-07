{ stdenv, fetchurl, pkgconfig, dbus_glib, zlib, pam, glib, 
  libX11, polkit, expat }:

stdenv.mkDerivation rec {
  name = "ConsoleKit-0.4.4";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/ConsoleKit/dist/${name}.tar.bz2";
    sha256 = "1bhnjwn7gakwfhqxrmwqwyjq46a11nn463qz0wlddrvgzdlhkh7h";
  };
  
  buildInputs = [ pkgconfig dbus_glib zlib pam glib libX11 polkit expat ];

  # For console-kit to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = "--enable-pam-module --with-pam-module-dir=$(out)/lib/security --localstatedir=/var --sysconfdir=/etc";

  installFlags = "sysconfdir=$(out)/etc DBUS_SYS_DIR=$(out)/etc/dbus-1/system.d"; # keep `make install' happy
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/ConsoleKit;
    description = "A framework for defining and tracking users, login sessions, and seats";
  };
}
