args: with args;

let

  version = "1.1.20";
  
  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "0zhl6cxlwfm9hsl7vm8ycif39805zsa1z8f0qnbfh54jmwccl7vg";
  };
  
  configureFlags = "--disable-static --localstatedir=/var --with-session-socket-dir=/tmp";
  
in rec {

  libs = stdenv.mkDerivation {
    name = "dbus-library-" + version;
    buildInputs = [pkgconfig expat];
    inherit src configureFlags;
    patchPhase = ''
      sed -i /mkinstalldirs.*localstatedir/d bus/Makefile.in
      sed -i '/SUBDIRS/s/ tools//' Makefile.in
    '';
  };

  tools = stdenv.mkDerivation {
    name = "dbus-tools-" + version;
    inherit src configureFlags;
    buildInputs = [pkgconfig expat libs]
      ++ (if useX11 then [libX11 libICE libSM] else []);
    postConfigure = "cd tools";

    NIX_LDFLAGS = "-ldbus-1";
    makeFlags = "DBUS_DAEMONDIR=${daemon}/bin";

    patchPhase = ''
      sed -i 's@ $(top_builddir)/dbus/libdbus-1.la@@' tools/Makefile.in
      sed -i '/mkdir.*localstate/d' tools/Makefile.in
    '';
  };

  # I'm too lazy to separate daemon and libs now.
  daemon = libs;
  
  # FIXME TODO
  # After merger it will be better to correct upstart-job instead.
  outPath = daemon.outPath;
  
}
