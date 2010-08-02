{ stdenv, fetchurl, pkgconfig, expat, libX11, libICE, libSM, useX11 ? true }:

let
  version = "1.2.24";
  
  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "0j2wb79kndq4b1qqr59n1g6s0lm7yp6r9ny3skimadkh9a7p8b7i";
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
  
  # FIXME TODO
  # After merger it will be better to correct upstart-job instead.
  outPath = daemon.outPath;
}
