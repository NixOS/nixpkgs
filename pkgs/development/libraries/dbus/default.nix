{ stdenv
, lib
, fetchurl
, pkg-config
, expat
, enableSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isStatic
, systemd
, audit
, libapparmor
, dbus
, docbook_xml_dtd_44
, docbook-xsl-nons
, xmlto
, autoreconfHook
, autoconf-archive
, x11Support ? (stdenv.isLinux || stdenv.isDarwin)
, xorg
}:

stdenv.mkDerivation rec {
  pname = "dbus";
  version = "1.14.4";

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.xz";
    sha256 = "sha256-fA+bjl7A/yR5OD5iwAhKOimvme3xUU6fZZuBsw1ONT4=";
  };

  patches = lib.optional stdenv.isSunOS ./implement-getgrouplist.patch;

  postPatch = ''
    substituteInPlace bus/Makefile.am \
      --replace 'install-data-hook:' 'disabled:' \
      --replace '$(mkinstalldirs) $(DESTDIR)$(localstatedir)/run/dbus' ':'
    substituteInPlace tools/Makefile.am \
      --replace 'install-data-local:' 'disabled:' \
      --replace 'installcheck-local:' 'disabled:'
  '' + /* cleanup of runtime references */ ''
    substituteInPlace ./dbus/dbus-sysdeps-unix.c \
      --replace 'DBUS_BINDIR "/dbus-launch"' "\"$lib/bin/dbus-launch\""
    substituteInPlace ./tools/dbus-launch.c \
      --replace 'DBUS_DAEMONDIR"/dbus-daemon"' '"/run/current-system/sw/bin/dbus-daemon"'
  '';

  outputs = [ "out" "dev" "lib" "doc" "man" ];

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    docbook_xml_dtd_44
    docbook-xsl-nons
    xmlto
  ];

  propagatedBuildInputs = [
    expat
  ];

  buildInputs =
    lib.optionals x11Support (with xorg; [
      libX11
      libICE
      libSM
    ]) ++ lib.optional enableSystemd systemd
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
  ++ lib.optionals stdenv.isLinux [ "--enable-apparmor" "--enable-libaudit" ]
  ++ lib.optionals enableSystemd [ "SYSTEMCTL=${systemd}/bin/systemctl" ];

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
