{ stdenv, fetchurl, pkgconfig, autoconf, automake, libtool
, expat, systemd, glib, dbus_glib, python
, libX11, libICE, libSM, useX11 ? true }:

let
  version = "1.6.8"; # 1.7.* isn't recommended, even for gnome 3.8
  sha256 = "1b0vq5b81synr0hqsfyypyq5yw305q0fq1f9alzv3vmb73pp04zw";

  inherit (stdenv) lib;

  buildInputsX = lib.optionals useX11 [ libX11 libICE libSM ];

  # also other parts than "libs" need this statically linked lib
  makeInternalLib = "(cd dbus && make libdbus-internal.la)";


  # A generic builder for individual parts (subdirs) of D-Bus
  dbus_drv = name: subdirs: merge: stdenv.mkDerivation (lib.mergeAttrsByFuncDefaultsClean [{

    name = "dbus-${name}-${version}";

    src = fetchurl {
      url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
      inherit sha256;
    };

    configureFlags = [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-session-socket-dir=/tmp"
      "--with-systemdsystemunitdir=$(out)/lib/systemd"
    ];

    preConfigure = ''
      patchShebangs .
      substituteInPlace tools/Makefile.am --replace 'install-localstatelibDATA:' 'disabled:'
      autoreconf -fi
    '';

    installFlags = "sysconfdir=$(out)/etc";

    doCheck = true;

    patches = [
      ./ignore-missing-includedirs.patch ./implement-getgrouplist.patch
      ./ucred-dirty-hack.patch ./no-create-dirs.patch
    ];

    nativeBuildInputs = [ pkgconfig ];
    propagatedBuildInputs = [ expat ];
    buildInputs = [ autoconf automake libtool ]; # ToDo: optional selinux?

    # build only the specified subdirs
    postPatch = "sed '/SUBDIRS/s/=.*/=" + subdirs + "/' -i Makefile.am\n"
      # use already packaged libdbus instead of trying to build it again
      + lib.optionalString (name != "libs") ''
          for mfile in */Makefile.am; do
            sed 's,\$(top_builddir)/dbus/\(libdbus-[0-9]\),${libs}/lib/\1,g' -i "$mfile"
          done
        '';

  } merge ]);

  libs = dbus_drv "libs" "dbus" {
    buildInputs = [ systemd.headers ];
    patches = [ ./systemd.patch ]; # bypass systemd detection

    # Enable X11 autolaunch support in libdbus. This doesn't actually depend on X11
    # (it just execs dbus-launch in dbus.tools), contrary to what the configure script demands.
    NIX_CFLAGS_COMPILE = "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
  };

in rec {

  # This package has been split because most applications only need dbus.lib
  # which serves as an interface to a *system-wide* daemon,
  # see e.g. http://en.wikipedia.org/wiki/D-Bus#Architecture .
  # Also some circular dependencies get split by this (like with systemd).

  inherit libs;

  tools = dbus_drv "tools" "tools" {
    configureFlags = [ "--with-dbus-daemondir=${daemon}/bin" ];
    buildInputs = buildInputsX ++ [ libs daemon systemd dbus_glib ];
    NIX_CFLAGS_LINK = "-Wl,--as-needed -ldbus-1";
  };

  daemon = dbus_drv "daemon" "bus" {
    preBuild = makeInternalLib;
    buildInputs = [ systemd ];
  };

  # Some of the tests don't work yet; in fact, @vcunat tried several packages
  # containing dbus testing, and all of them have some test failure.
  tests = dbus_drv "tests" "test" {
    preBuild = makeInternalLib;
    buildInputs = buildInputsX ++ [ systemd libs tools daemon dbus_glib python ];
    NIX_CFLAGS_LINK = "-Wl,--as-needed -ldbus-1";
  };

  docs = dbus_drv "docs" "doc" {
    postInstall = ''rm -r "$out/lib"'';
  };
}
