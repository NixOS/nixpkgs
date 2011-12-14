{ stdenv, fetchurl, pkgconfig, expat, libX11, libICE, libSM, useX11 ? true }:

let
  version = "1.4.16";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1ii93d0lzj5xm564dcq6ca4s0nvm5i9fx3jp0s7i9hlc5wkfd3hx";
  };

  patches = [ ./ignore-missing-includedirs.patch ];

  configureFlags = "--localstatedir=/var --sysconfdir=/etc --with-session-socket-dir=/tmp";

in rec {

  libs = stdenv.mkDerivation {
    name = "dbus-library-" + version;

    buildNativeInputs = [ pkgconfig ];

    buildInputs = [ expat ];

    inherit src patches configureFlags;

    preConfigure =
      ''
        sed -i '/mkinstalldirs.*localstatedir/d' bus/Makefile.in
        sed -i '/SUBDIRS/s/ tools//' Makefile.in
      '';

    # Enable X11 autolaunch support in libdbus.  This doesn't actually
    # depend on X11 (it just execs dbus-launch in dbus.tools),
    # contrary to what the configure script demands.
    NIX_CFLAGS_COMPILE = "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";

    installFlags = "sysconfdir=$(out)/etc";
  };

  tools = stdenv.mkDerivation {
    name = "dbus-tools-" + version;

    inherit src patches;

    configureFlags = "${configureFlags} --with-dbus-daemondir=${daemon}/bin";

    buildNativeInputs = [ pkgconfig ];

    buildInputs = [ expat libs ]
      ++ stdenv.lib.optionals useX11 [ libX11 libICE libSM ];

    NIX_LDFLAGS = "-ldbus-1";

    preConfigure =
      ''
        sed -i 's@$(top_builddir)/dbus/libdbus-1.la@@' tools/Makefile.in
        substituteInPlace tools/Makefile.in --replace 'install-localstatelibDATA:' 'disabled:'
      '';

    postConfigure = "cd tools";
  };

  # I'm too lazy to separate daemon and libs now.
  daemon = libs;
}
