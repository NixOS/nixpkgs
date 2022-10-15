{ stdenv
, lib
, fetchpatch
, fetchurl
, pkg-config
, expat
, enableSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isStatic
, systemdMinimal
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
  version = "1.14.0";

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus/dbus-${version}.tar.xz";
    sha256 = "sha256-zNfM43WW4KGVWP1mSNEnKrQ/AR2AyGNa6o/QutWK69Q=";
  };

  patches = [
    # Fix dbus-daemon crashing when running tests due to long XDG_DATA_DIRS.
    # https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/302
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/dbus/dbus/-/commit/b551b3e9737958216a1a9d359150a4110a9d0549.patch";
      sha256 = "kOVjlklZzKvBZXmmrE1UiO4XWRoBLViGwdn6/eDH+DY=";
    })
  ] ++ (lib.optional stdenv.isSunOS ./implement-getgrouplist.patch);

  postPatch = ''
    # We need to generate the file ourselves.
    # https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/317
    rm doc/catalog.xml

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
    ]) ++ lib.optional enableSystemd systemdMinimal
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
  ++ lib.optionals enableSystemd [ "SYSTEMCTL=${systemdMinimal}/bin/systemctl" ];

  NIX_CFLAGS_LINK = lib.optionalString (!stdenv.isDarwin) "-Wl,--as-needed";

  enableParallelBuilding = true;

  doCheck = true;

  makeFlags = [
    # Fix paths in XML catalog broken by mismatching build/install datadir.
    "dtddir=${placeholder "out"}/share/xml/dbus-1"
  ];

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
