{ stdenv, fetchurl, pkgconfig, dbus_glib, zlib, pam, glib, 
  libX11, polkit, expat
  , ...}:

stdenv.mkDerivation rec {
  name = "consolekit-0.4.1";
  
  src = fetchurl {
    url = http://www.freedesktop.org/software/ConsoleKit/dist/ConsoleKit-0.4.1.tar.bz2;
    sha256 = "0gj0airrgyi14a06w3d4407g62bs5a1cam2h64s50x3d2k3ascph";
  };
  
  buildInputs = [ pkgconfig dbus_glib zlib pam glib libX11 polkit expat ];
  patches = [ ./0001-Don-t-daemonize-when-activated.patch
    ./0002-Don-t-take-bus-name-until-ready.patch ];

  # For console-kit to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = "--enable-pam-module --with-pam-module-dir=$(out)/lib/security --localstatedir=/var --sysconfdir=/etc";

  installFlags = "sysconfdir=$(out)/etc DBUS_SYS_DIR=$(out)/etc/dbus-1/system.d"; # keep `make install' happy
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/ConsoleKit;
    description = "A framework for defining and tracking users, login sessions, and seats";
  };
}
