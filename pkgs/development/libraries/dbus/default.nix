{ stdenv, fetchurl, pkgconfig, autoreconfHook
, expat, systemd, glib, dbus_glib, python
, libX11 ? null, libICE ? null, libSM ? null, x11Support ? (stdenv.isLinux || stdenv.isDarwin) }:

assert x11Support -> libX11 != null
                  && libICE != null
                  && libSM != null;

let
  version = "1.8.20";
  sha256 = "0fkh3d5r57a659hw9lqnw4v0bc5556vx54fsf7l9c732ci6byksw";

  inherit (stdenv) lib;

  buildInputsX = lib.optionals x11Support [ libX11 libICE libSM ];

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

    nativeBuildInputs = [ pkgconfig autoreconfHook ];
    propagatedBuildInputs = [ expat ];

    preAutoreconf = ''
      substituteInPlace tools/Makefile.am --replace 'install-localstatelibDATA:' 'disabled:'
    '';

    preConfigure = ''
      patchShebangs .
    '';

    configureFlags = [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-session-socket-dir=/tmp"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ] ++ lib.optional (!x11Support) "--without-x";

    enableParallelBuilding = true;

    doCheck = true;

    installFlags = "sysconfdir=$(out)/etc";

  } merge ]);

  libs = dbus_drv "libs" "dbus" {
    # Enable X11 autolaunch support in libdbus. This doesn't actually depend on X11
    # (it just execs dbus-launch in dbus.tools), contrary to what the configure script demands.
    NIX_CFLAGS_COMPILE = "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
    buildInputs = [ systemdOrEmpty ];
    meta.platforms = stdenv.lib.platforms.all;
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
      stdenv.lib.optionalString (!stdenv.isDarwin && !stdenv.isSunOS) "-Wl,--as-needed "
      + "-ldbus-1";

    # don't provide another dbus-1.pc (with incorrect include and link dirs),
    # also remove useless empty dirs
    postInstall = ''
      rm "$out"/lib/pkgconfig/dbus-1.pc
      rmdir --parents --ignore-fail-on-non-empty "$out"/{lib/pkgconfig,share/dbus-1/*}
    '';

    meta.platforms = with stdenv.lib.platforms; allBut darwin;
  };

  daemon = tools;

  docs = dbus_drv "docs" "doc" {
    postInstall = ''rm -r "$out/lib"'';
  };
};
in attrs.libs // attrs

