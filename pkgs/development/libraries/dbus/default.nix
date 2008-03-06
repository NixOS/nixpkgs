args: with args;
let
  version = "1.0.2";
  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1jn652zb81mczsx4rdcwrrzj3lfhx9d107zjfnasc4l5yljl204a";
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
