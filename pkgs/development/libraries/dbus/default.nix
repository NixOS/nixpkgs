{ stdenv, lib, fetchurl, pkgconfig, expat, systemd
, libX11 ? null, libICE ? null, libSM ? null, x11Support ? (stdenv.isLinux || stdenv.isDarwin) }:

assert x11Support -> libX11 != null
                  && libICE != null
                  && libSM != null;

let
  version = "1.10.14";
  sha256 = "10x0wvv2ly4lyyfd42k4xw0ar5qdbi9cksw3l5fcwf1y6mq8y8r3";

self =  stdenv.mkDerivation {
    name = "dbus-${version}";

    src = fetchurl {
      url = "http://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
      inherit sha256;
    };

    patches = lib.optional stdenv.isSunOS ./implement-getgrouplist.patch;
    postPatch = ''
      substituteInPlace tools/Makefile.in \
        --replace 'install-localstatelibDATA:' 'disabled:' \
        --replace 'install-data-local:' 'disabled:' \
        --replace 'installcheck-local:' 'disabled:'
      substituteInPlace bus/Makefile.in \
        --replace '$(mkinstalldirs) $(DESTDIR)$(localstatedir)/run/dbus' ':'
    '' + /* cleanup of runtime references */ ''
      substituteInPlace ./dbus/dbus-sysdeps-unix.c \
        --replace 'DBUS_BINDIR "/dbus-launch"' "\"$lib/bin/dbus-launch\""
      substituteInPlace ./tools/dbus-launch.c \
        --replace 'DBUS_DAEMONDIR"/dbus-daemon"' '"/run/current-system/sw/bin/dbus-daemon"'
    '';

    outputs = [ "out" "dev" "lib" "doc" ];

    nativeBuildInputs = [ pkgconfig ];
    propagatedBuildInputs = [ expat ];
    buildInputs = lib.optional stdenv.isLinux systemd
      ++ lib.optionals x11Support [ libX11 libICE libSM ];
    # ToDo: optional selinux?

    configureFlags = [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-session-socket-dir=/tmp"
      "--with-system-pid-file=/run/dbus/pid"
      "--with-system-socket=/run/dbus/system_bus_socket"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
      "--with-systemduserunitdir=$(out)/etc/systemd/user"
      "--enable-user-session"
      # this package installs nothing into those dirs and they create a dependency
      "--datadir=/run/current-system/sw/share"
      "--libexecdir=$(out)/libexec" # we don't need dbus-daemon-launch-helper
    ] ++ lib.optional (!x11Support) "--without-x";

    # Enable X11 autolaunch support in libdbus. This doesn't actually depend on X11
    # (it just execs dbus-launch in dbus.tools), contrary to what the configure script demands.
    # problems building without x11Support so disabled in that case for now
    NIX_CFLAGS_COMPILE = lib.optionalString x11Support "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
    NIX_CFLAGS_LINK = lib.optionalString (!stdenv.isDarwin) "-Wl,--as-needed";

    enableParallelBuilding = true;

    doCheck = true;

    installFlags = "sysconfdir=$(out)/etc datadir=$(out)/share";

    # it's executed from $lib by absolute path
    postFixup = ''
      moveToOutput bin/dbus-launch "$lib"
      ln -s "$lib/bin/dbus-launch" "$out/bin/"
    '';

    passthru = {
      dbus-launch = "${self.lib}/bin/dbus-launch";
      daemon = self.out;
    };

    meta = with stdenv.lib; {
      description = "Simple interprocess messaging system";
      homepage = http://www.freedesktop.org/wiki/Software/dbus/;
      license = licenses.gpl2Plus; # most is also under AFL-2.1
      platforms = platforms.unix;
    };
  };
in self
