{ stdenv, fetchurl, pkgconfig, expat, libX11, libICE, libSM, useX11 ? true }:

let
  version = "1.6.4";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1wacqyfkcpayg7f8rvx9awqg275n5pksxq5q7y21lxjx85x6pfjz";
  };

  patches = [ ./ignore-missing-includedirs.patch ];

  configureFlags = "--localstatedir=/var --sysconfdir=/etc --with-session-socket-dir=/tmp";

in rec {

  libs = stdenv.mkDerivation {
    name = "dbus-library-" + version;

    nativeBuildInputs = [ pkgconfig ];

    buildInputs = [ expat ];

    # FIXME: dbus has optional systemd integration when checking
    # at_console policies.  How to enable this without introducing a
    # circular dependency between dbus and systemd?

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

    nativeBuildInputs = [ pkgconfig ];

    buildInputs = [ expat libs ]
      ++ stdenv.lib.optionals useX11 [ libX11 libICE libSM ];

    NIX_LDFLAGS = "-ldbus-1";

    preConfigure =
      ''
        sed -i 's@$(top_builddir)/dbus/libdbus-1.la@@' tools/Makefile.in
        substituteInPlace tools/Makefile.in --replace 'install-localstatelibDATA:' 'disabled:'
      '';

    postConfigure = "cd tools";

    installFlags = "localstatedir=$TMPDIR/var";
  };

  # I'm too lazy to separate daemon and libs now.
  daemon = libs;
}
