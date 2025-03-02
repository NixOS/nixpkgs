{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  expat,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
  systemdMinimal,
  audit,
  libcap_ng,
  libapparmor,
  dbus,
  docbook_xml_dtd_44,
  docbook-xsl-nons,
  libxslt,
  meson,
  ninja,
  python3,
  x11Support ? (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin),
  xorg,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus";
  version = "1.16.2";

  outputs = [
    "out"
    "dev"
    "lib"
    "doc"
    "man"
  ];

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus/dbus-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-C6KhpLFq/nvOssB+nOmajCw1COXewpDbtkM4S9a+t+I=";
  };

  patches = [
    # Implement getgrouplist for platforms where it is not available (e.g. Illumos/Solaris)
    ./implement-getgrouplist.patch

    # Add a Meson configuration option that will allow us to use a different
    # `datadir` for installation from the one that will be compiled into dbus.
    # This is necessary to allow NixOS to manage dbus service definitions,
    # since the `datadir` in the package will be immutable. But we still want
    # to install the files to the latter, since there is no other suitable
    # place for the project to install them.
    #
    # We will also just remove installation of empty `${runstatedir}/dbus`
    # and `${localstatedir}/lib/dbus` since these are useless in the package.
    ./meson-install-dirs.patch
  ];

  separateDebugInfo = true;

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    docbook_xml_dtd_44
    docbook-xsl-nons
    libxslt # for xsltproc
    python3
  ];

  buildInputs =
    [
      expat
    ]
    ++ lib.optionals x11Support (
      with xorg;
      [
        libX11
        libICE
        libSM
      ]
    )
    ++ lib.optional enableSystemd systemdMinimal
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      audit
      libcap_ng
      libapparmor
    ];

  __darwinAllowLocalNetworking = true;

  mesonFlags = [
    "--libexecdir=${placeholder "out"}/libexec"
    # datadir from which dbus will load files will be managed by the NixOS module:
    "--datadir=/etc"
    # But we still want to install stuff to the package:
    "-Dinstall_datadir=${placeholder "out"}/share"
    "--localstatedir=/var"
    "-Druntime_dir=/run"
    "--sysconfdir=/etc"
    "-Dinstall_sysconfdir=${placeholder "out"}/etc"
    "-Ddoxygen_docs=disabled"
    "-Dducktype_docs=disabled"
    "-Dqt_help=disabled"
    "-Drelocation=disabled" # Conflicts with multiple outputs
    "-Dmodular_tests=disabled" # Requires glib
    "-Dsession_socket_dir=/tmp"
    "-Dsystemd_system_unitdir=${placeholder "out"}/etc/systemd/system"
    "-Dsystemd_user_unitdir=${placeholder "out"}/etc/systemd/user"
    (lib.mesonEnable "x11_autolaunch" x11Support)
    (lib.mesonEnable "apparmor" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "libaudit" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "kqueue" (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isBSD))
    (lib.mesonEnable "launchd" stdenv.hostPlatform.isDarwin)
    "-Dselinux=disabled"
    "--cross-file=${writeText "crossfile.ini" ''
      [binaries]
      systemctl = '${systemdMinimal}/bin/systemctl'
    ''}"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      test/data/copy_data_for_tests.py \
      meson_post_install.py

    # Cleanup of runtime references
    substituteInPlace ./dbus/dbus-sysdeps-unix.c \
      --replace-fail 'DBUS_BINDIR "/dbus-launch"' "\"$lib/bin/dbus-launch\""
    substituteInPlace ./tools/dbus-launch.c \
      --replace-fail 'DBUS_DAEMONDIR"/dbus-daemon"' '"/run/current-system/sw/bin/dbus-daemon"'
  '';

  postFixup = ''
    # It's executed from $lib by absolute path
    moveToOutput bin/dbus-launch "$lib"
    ln -s "$lib/bin/dbus-launch" "$out/bin/"
  '';

  passthru = {
    dbus-launch = "${dbus.lib}/bin/dbus-launch";
  };

  meta = with lib; {
    description = "Simple interprocess messaging system";
    homepage = "https://www.freedesktop.org/wiki/Software/dbus/";
    changelog = "https://gitlab.freedesktop.org/dbus/dbus/-/blob/dbus-${finalAttrs.version}/NEWS";
    license = licenses.gpl2Plus; # most is also under AFL-2.1
    maintainers = teams.freedesktop.members;
    platforms = platforms.unix;
  };
})
