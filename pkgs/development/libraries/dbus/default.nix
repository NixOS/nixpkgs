{ stdenv, fetchurl, pkgconfig, expat, libX11, libICE, libSM, useX11 ? true }:

stdenv.mkDerivation rec {
  name = "dbus-all-${version}";
  version = "1.4.16";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1ii93d0lzj5xm564dcq6ca4s0nvm5i9fx3jp0s7i9hlc5wkfd3hx";
  };

  patches = [ ./ignore-missing-includedirs.patch ];

  buildNativeInputs = [ pkgconfig ];

  buildInputs = [ expat ]
    ++ stdenv.lib.optionals useX11 [ libX11 libICE libSM ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-session-socket-dir=/tmp"
  ];

  preConfigure = ''
    sed -i '/mkinstalldirs.*localstatedir/d' bus/Makefile.in
    substituteInPlace tools/Makefile.in --replace 'install-localstatelibDATA:' 'disabled:'
  '';

  # Enable X11 autolaunch support in libdbus.  This doesn't actually
  # depend on X11 (it just execs dbus-launch in dbus),
  # contrary to what the configure script demands.
  NIX_CFLAGS_COMPILE = "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";

  installFlags = "sysconfdir=$(out)/etc";
}
