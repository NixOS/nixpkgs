{ stdenv
, lib
, fetchurl
, pkg-config
, expat
, enableSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isMusl
, systemd
, audit
, libapparmor
, libX11 ? null
, libICE ? null
, libSM ? null
, x11Support ? (stdenv.isLinux || stdenv.isDarwin)
, dbus
, docbook_xml_dtd_44
, docbook-xsl-nons
, xmlto
}:

stdenv.mkDerivation rec {
  pname = "dbus";
  version = "1.12.20";

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.gz";
    sha256 = "1zp5gpx61v1cpqf2zwb1cidhp9xylvw49d3zydkxqk6b1qa20xpp";
  };

  patches = [
    # 'generate.consistent.ids=1' ensures reproducible docs, for further details see
    # http://docbook.sourceforge.net/release/xsl/current/doc/html/generate.consistent.ids.html
    # Also applied upstream in https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/189,
    # expected in version 1.14
    ./docs-reproducible-ids.patch
  ] ++ (lib.optional stdenv.isSunOS ./implement-getgrouplist.patch);

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

  outputs = [ "out" "dev" "lib" "doc" "man" ];

  nativeBuildInputs = [
    pkg-config
    docbook_xml_dtd_44
    docbook-xsl-nons
    xmlto
  ];

  propagatedBuildInputs = [
    expat
  ];

  buildInputs =
    lib.optionals x11Support [
      libX11
      libICE
      libSM
    ] ++ lib.optional enableSystemd systemd
    ++ lib.optionals stdenv.isLinux [ audit libapparmor ];
  # ToDo: optional selinux?

  configureFlags = [
    "--enable-user-session"
    "--enable-xml-docs"
    "--libexecdir=${placeholder "out"}/libexec"
    "--datadir=/etc"
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-session-socket-dir=/tmp"
    "--with-system-pid-file=/run/dbus/pid"
    "--with-system-socket=/run/dbus/system_bus_socket"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
  ] ++ lib.optional (!x11Support) "--without-x"
  ++ lib.optionals stdenv.isLinux [ "--enable-apparmor" "--enable-libaudit" ];

  # Enable X11 autolaunch support in libdbus. This doesn't actually depend on X11
  # (it just execs dbus-launch in dbus.tools), contrary to what the configure script demands.
  # problems building without x11Support so disabled in that case for now
  NIX_CFLAGS_COMPILE = lib.optionalString x11Support "-DDBUS_ENABLE_X11_AUTOLAUNCH=1";
  NIX_CFLAGS_LINK = lib.optionalString (!stdenv.isDarwin) "-Wl,--as-needed";

  enableParallelBuilding = true;

  doCheck = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "datadir=${placeholder "out"}/share"
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

  meta = with lib; {
    description = "Simple interprocess messaging system";
    homepage = "http://www.freedesktop.org/wiki/Software/dbus/";
    license = licenses.gpl2Plus; # most is also under AFL-2.1
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
    platforms = platforms.unix;
  };
}
