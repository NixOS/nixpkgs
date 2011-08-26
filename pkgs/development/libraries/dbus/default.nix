{ stdenv, fetchurl, pkgconfig, expat, libX11, libICE, libSM, useX11 ? true }:

let
  version = "1.4.14";
  
  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "0xsqkq2q2hb09dcdsw0y359zvml480h79qvl9g31r7da57y7xwj7";
  };

  patches = [ ./ignore-missing-includedirs.patch ];
  
  configureFlags = "--localstatedir=/var --sysconfdir=/etc --with-session-socket-dir=/tmp";
  
in rec {

  libs = stdenv.mkDerivation {
    name = "dbus-library-" + version;
    
    buildInputs = [ pkgconfig expat ];
    
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
    
    buildInputs = [ pkgconfig expat libs ]
      ++ stdenv.lib.optionals useX11 [ libX11 libICE libSM ];
      
    NIX_LDFLAGS = "-ldbus-1";

    preConfigure =
      ''
        sed -i 's@ $(top_builddir)/dbus/libdbus-1.la@@' tools/Makefile.in
        substituteInPlace tools/Makefile.in --replace 'install-localstatelibDATA:' 'disabled:'
      '';

    postConfigure = "cd tools";
  };

  # I'm too lazy to separate daemon and libs now.
  daemon = libs;
}
