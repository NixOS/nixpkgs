{ stdenv
, lib
, fetchurl
, pkgconfig
, expat
, systemd
, libX11 ? null
, libICE ? null
, libSM ? null
, x11Support ? (stdenv.isLinux || stdenv.isDarwin)
, dbus
}:

assert
  x11Support ->
    libX11 != null && libICE != null && libSM != null;

stdenv.mkDerivation rec {
  pname = "dbus";
  version = "1.12.16";

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "107ckxaff1cv4q6kmfdi2fb1nlsv03312a7kf6lb4biglhpjv8jl";
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

  nativeBuildInputs = [
    pkgconfig
  ];

  propagatedBuildInputs = [
    expat
  ];

  buildInputs = lib.optionals x11Support [
    libX11
    libICE
    libSM
  ] ++ lib.optional stdenv.isLinux systemd;
  # ToDo: optional selinux?

  configureFlags = [
    "--enable-user-session"
    "--libexecdir=${placeholder ''out''}/libexec"
    "--datadir=/etc"
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-session-socket-dir=/tmp"
    "--with-system-pid-file=/run/dbus/pid"
    "--with-system-socket=/run/dbus/system_bus_socket"
    "--with-systemdsystemunitdir=${placeholder ''out''}/etc/systemd/system"
    "--with-systemduserunitdir=${placeholder ''out''}/etc/systemd/user"
  ] ++ lib.optional (!x11Support) "--without-x";

  # Enable X11 autolaunch support in libdbus. This doesn't actually depend on X11
  # (it just execs dbus-launch in dbus.tools), contrary to what the configure script demands.
  # problems building without x11Support so disabled in that case for now
  NIX_CFLAGS_COMPILE = lib.optionalString x11Support "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
  NIX_CFLAGS_LINK = lib.optionalString (!stdenv.isDarwin) "-Wl,--as-needed";

  enableParallelBuilding = true;

  doCheck = true;

  installFlags = [
    "sysconfdir=${placeholder ''out''}/etc"
    "datadir=${placeholder ''out''}/share"
  ];

  # it's executed from $lib by absolute path
  postFixup = ''
    moveToOutput bin/dbus-launch "$lib"
    ln -s "$lib/bin/dbus-launch" "$out/bin/"
  '';

  passthru = {
    dbus-launch = "${dbus.lib}/bin/dbus-launch";
    daemon = dbus.out;
  };

  meta = with stdenv.lib; {
    description = "Simple interprocess messaging system";
    homepage = http://www.freedesktop.org/wiki/Software/dbus/;
    license = licenses.gpl2Plus; # most is also under AFL-2.1
    platforms = platforms.unix;
  };
}
