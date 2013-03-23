{ stdenv, fetchurl, pkgconfig, autoconf, automake, libtool
, expat, systemd, glib, dbus_glib, python
, libX11, libICE, libSM, useX11 ? true }:

let
  version = "1.6.4";

  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1wacqyfkcpayg7f8rvx9awqg275n5pksxq5q7y21lxjx85x6pfjz";
  };

  patches = [
    ./ignore-missing-includedirs.patch ./implement-getgrouplist.patch
    ./ucred-dirty-hack.patch ./no-create-dirs.patch
  ];

  # build only the specified subdirs
  postPatch = subdirs : "sed '/SUBDIRS/s/=.*/=" + subdirs + "/' -i Makefile.am\n"
    # use already packaged libdbus instead of trying to build it again
    + stdenv.lib.optionalString (subdirs != "dbus") ''
        for mfile in */Makefile.am; do
          sed 's,\$(top_builddir)/dbus/\(libdbus-[0-9]\),${libs}/lib/\1,g' -i "$mfile"
        done
      '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ autoconf automake libtool expat ]; # ToDo: optional selinux?

  buildInputsWithX = buildInputs ++ stdenv.lib.optionals useX11 [ libX11 libICE libSM ];

  preConfigure = ''
    patchShebangs .
    substituteInPlace tools/Makefile.am --replace 'install-localstatelibDATA:' 'disabled:'
    autoreconf -fi
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-session-socket-dir=/tmp"
    "--with-systemdsystemunitdir=$(out)/lib/systemd"
  ];

  # also other parts than "libs" need this statically linked lib
  postConfigure = "(cd dbus && make libdbus-internal.la)";

  doCheck = true;

  installFlags = "sysconfdir=$(out)/etc";


  libs = stdenv.mkDerivation {
    name = "dbus-library-" + version;

    inherit src nativeBuildInputs preConfigure configureFlags doCheck installFlags;

    buildInputs = buildInputs ++ [ systemd.headers ];

    patches = patches ++ [ ./systemd.patch ]; # bypass systemd detection

    postPatch = postPatch "dbus";

    # Enable X11 autolaunch support in libdbus.  This doesn't actually
    # depend on X11 (it just execs dbus-launch in dbus.tools),
    # contrary to what the configure script demands.
    NIX_CFLAGS_COMPILE = "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
  };

  tools = stdenv.mkDerivation {
    name = "dbus-tools-" + version;

    inherit src patches nativeBuildInputs preConfigure doCheck installFlags;

    configureFlags = configureFlags ++ [ "--with-dbus-daemondir=${daemon}/bin" ];

    buildInputs = buildInputsWithX ++ [ libs daemon systemd dbus_glib ];

    NIX_CFLAGS_LINK = "-Wl,--as-needed -ldbus-1";

    postPatch = postPatch "tools";
  };

  daemon = stdenv.mkDerivation {
    name = "dbus-daemon-" + version;

    inherit src patches nativeBuildInputs
      preConfigure configureFlags postConfigure doCheck installFlags;

    buildInputs = buildInputs ++ [ systemd ];

    postPatch = postPatch "bus";
  };

  tests = stdenv.mkDerivation {
    name = "dbus-tests-" + version;

    inherit src patches nativeBuildInputs
      preConfigure configureFlags postConfigure doCheck installFlags;

    buildInputs = buildInputsWithX ++ [ systemd libs tools daemon dbus_glib python ];

    postPatch = postPatch "test";

    NIX_CFLAGS_LINK = "-Wl,--as-needed -ldbus-1";
  };

  docs = stdenv.mkDerivation {
    name = "dbus-docs-" + version;

    inherit src patches nativeBuildInputs
      preConfigure configureFlags doCheck installFlags;

    buildInputs = buildInputs;

    postPatch = postPatch "doc";

    postInstall = ''rm -r "$out/lib"'';
  };

in {
  inherit libs daemon tools tests docs;

  dbus_libs   = libs;
  dbus_daemon = daemon;
  dbus_tools  = tools;
  dbus_tests  = tests;
  dbus_docs   = docs;
}
