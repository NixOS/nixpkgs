{ stdenv, fetchurl, pkgconfig, autoconf, automake, libtool
, expat, systemd, glib, dbus_glib, python
, libX11, libICE, libSM, useX11 ? (stdenv.isLinux || stdenv.isDarwin) }:

let
  version = "1.8.6";
  sha256 = "0gyjxd0gfpjs3fq5bx6aljb5f3zxky5zsq0yfqr9ywbv03587vgd";

  inherit (stdenv) lib;

  buildInputsX = lib.optionals useX11 [ libX11 libICE libSM ];

  # also other parts than "libs" need this statically linked lib
  makeInternalLib = "(cd dbus && make libdbus-internal.la)";

  systemdOrEmpty = lib.optional stdenv.isLinux systemd;

  # A generic builder for individual parts (subdirs) of D-Bus
  dbus_drv = name: subdirs: merge: stdenv.mkDerivation (lib.mergeAttrsByFuncDefaultsClean [{

    name = "dbus-${name}-${version}";

    src = fetchurl {
      url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
      inherit sha256;
    };

    patches = [
        ./ignore-missing-includedirs.patch
        ./ucred-dirty-hack.patch
        ./no-create-dirs.patch
      ]
      ++ lib.optional (stdenv.isSunOS || stdenv.isLinux) ./implement-getgrouplist.patch
      ;

    # build only the specified subdirs
    postPatch = "sed '/SUBDIRS/s/=.*/=" + subdirs + "/' -i Makefile.am\n"
      # use already packaged libdbus instead of trying to build it again
      + lib.optionalString (name != "libs") ''
          for mfile in */Makefile.am; do
            sed 's,\$(top_builddir)/dbus/\(libdbus-[0-9]\),${libs}/lib/\1,g' -i "$mfile"
          done
        '';

    nativeBuildInputs = [ pkgconfig ];
    propagatedBuildInputs = [ expat ];
    buildInputs = [ autoconf automake libtool ]; # ToDo: optional selinux?

    preConfigure = ''
      patchShebangs .
      substituteInPlace tools/Makefile.am --replace 'install-localstatelibDATA:' 'disabled:'
      autoreconf -fi
    '';

    configureFlags = [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-session-socket-dir=/tmp"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ];

    enableParallelBuilding = true;

    doCheck = true;

    installFlags = "sysconfdir=$(out)/etc";

  } merge ]);

  libs = dbus_drv "libs" "dbus" {
    # Enable X11 autolaunch support in libdbus. This doesn't actually depend on X11
    # (it just execs dbus-launch in dbus.tools), contrary to what the configure script demands.
    NIX_CFLAGS_COMPILE = "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
    buildInputs = [ systemdOrEmpty ];
  };


  attrs = rec {
  # If you change much fix indentation

  # This package has been split because most applications only need dbus.lib
  # which serves as an interface to a *system-wide* daemon,
  # see e.g. http://en.wikipedia.org/wiki/D-Bus#Architecture .

  inherit libs;

  tools = dbus_drv "tools" "tools bus" {
    preBuild = makeInternalLib;
    buildInputs = buildInputsX ++ systemdOrEmpty ++ [ libs ];
    NIX_CFLAGS_LINK =
      stdenv.lib.optionalString (!stdenv.isDarwin) "-Wl,--as-needed "
      + "-ldbus-1";

    meta.platforms = with stdenv.lib.platforms; allBut darwin;
  };

  daemon = tools;

  docs = dbus_drv "docs" "doc" {
    postInstall = ''rm -r "$out/lib"'';
  };
};
in attrs.libs // attrs
