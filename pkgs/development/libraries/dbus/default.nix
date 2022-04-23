{ stdenv
, lib
, fetchpatch
, fetchurl
, pkg-config
, expat
, enableSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isStatic
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
, autoreconfHook
, autoconf-archive
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
    # AC_PATH_XTRA doesn't seem to find X11 libs even though libX11 seems
    # to provide valid pkg-config files. This replace AC_PATH_XTRA with
    # PKG_CHECK_MODULES.
    # MR merged cf https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/212/diffs?commit_id=23880a181e82ee7f
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/dbus/dbus/-/commit/6bfaea0707ba1a7788c4b6d30c18fb094f3a1dd4.patch";
      sha256 = "1d8ay55n2ksw5faqx3hsdpfni3xl3gq9hnjl65073xcfnx67x8d2";
    })

    # Fix dbus-daemon crashing when running tests due to long XDG_DATA_DIRS.
    # https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/302
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/dbus/dbus/-/commit/b551b3e9737958216a1a9d359150a4110a9d0549.patch";
      sha256 = "kOVjlklZzKvBZXmmrE1UiO4XWRoBLViGwdn6/eDH+DY=";
    })
  ] ++ (lib.optional stdenv.isSunOS ./implement-getgrouplist.patch);

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
