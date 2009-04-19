{stdenv, fetchurl, pkgconfig, expat, libX11, libICE, libSM, useX11 ? true}:

let
  version = "1.2.4";
  
  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1f7v79ws34mh6j75fk6w4w9v441vffll0fwf5vk94mwa0bc28g5b";
  };
  
  configureFlags = "--disable-static --localstatedir=/var --with-session-socket-dir=/tmp";
  
in rec {

  libs = stdenv.mkDerivation {
    name = "dbus-library-" + version;
    
    buildInputs = [pkgconfig expat];
    
    inherit src configureFlags;
    
    patchPhase = ''
      sed -i '/mkinstalldirs.*localstatedir/d' bus/Makefile.in
      sed -i '/SUBDIRS/s/ tools//' Makefile.in
    '';
  };

  tools = stdenv.mkDerivation {
    name = "dbus-tools-" + version;

    inherit src configureFlags;
    
    buildInputs = [pkgconfig expat libs]
      ++ stdenv.lib.optionals useX11 [libX11 libICE libSM];
      
    postConfigure = "cd tools";

    NIX_LDFLAGS = "-ldbus-1";
    
    makeFlags = "DBUS_DAEMONDIR=${daemon}/bin";

    patchPhase = ''
      sed -i 's@ $(top_builddir)/dbus/libdbus-1.la@@' tools/Makefile.in
      substituteInPlace tools/Makefile.in --replace 'install-localstatelibDATA:' 'disabled:'
    '';
  };

  # I'm too lazy to separate daemon and libs now.
  daemon = libs;
  
  # FIXME TODO
  # After merger it will be better to correct upstart-job instead.
  outPath = daemon.outPath;
}
