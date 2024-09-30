{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glib
, expat
, pam
, meson
, mesonEmulatorHook
, ninja
, perl
, python3
, gettext
, duktape
, gobject-introspection
, libxslt
, docbook-xsl-nons
, dbus
, docbook_xml_dtd_412
, gtk-doc
, coreutils
, fetchpatch
, useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal
, systemdMinimal
, elogind
, buildPackages
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
# A few tests currently fail on musl (polkitunixusertest, polkitunixgrouptest, polkitidentitytest segfault).
# Not yet investigated; it may be due to the "Make netgroup support optional"
# patch not updating the tests correctly yet, or doing something wrong,
# or being unrelated to that.
, doCheck ? (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl)
}:

let
  system = "/run/current-system/sw";
  setuid = "/run/wrappers/bin";
in
stdenv.mkDerivation rec {
  pname = "polkit";
  version = "124";

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  # Tarballs do not contain subprojects.
  src = fetchFromGitHub {
    owner = "polkit-org";
    repo = "polkit";
    rev = version;
    hash = "sha256-Vc9G2xK6U1cX+xW2BnKp3oS/ACbSXS/lztbFP5oJOlM=";
  };

  patches = [
    # Allow changing base for paths in pkg-config file as before.
    # https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/100
    ./0001-build-Use-datarootdir-in-Meson-generated-pkg-config-.patch

    ./elogind.patch

    # FIXME: remove in the next release
    # https://github.com/NixOS/nixpkgs/issues/18012
    (fetchpatch {
      url = "https://github.com/polkit-org/polkit/commit/f93c7466039ea3403e0576928aeb620b806d0cce.patch";
      sha256 = "sha256-cF0nNovYmyr+XixpBgQFF0A+oJeSPGZgTkgDQkQuof8=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    glib
    pkg-config
    gettext
    meson
    ninja
    perl

    # man pages
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_412
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    gtk-doc
  ] ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    expat
    pam
    dbus
    duktape
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # On Linux, fall back to elogind when systemd support is off.
    (if useSystemd then systemdMinimal else elogind)
  ];

  propagatedBuildInputs = [
    glib # in .pc Requires
  ];

  nativeCheckInputs = [
    dbus
    (python3.pythonOnBuildForHost.withPackages (pp: with pp; [
      dbus-python
      (python-dbusmock.overridePythonAttrs (attrs: {
        # Avoid dependency cycle.
        doCheck = false;
      }))
    ]))
  ];

  env = {
    PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
    PKG_CONFIG_SYSTEMD_SYSUSERS_DIR = "${placeholder "out"}/lib/sysusers.d";
  };

  mesonFlags = [
    "--datadir=${system}/share"
    "--sysconfdir=/etc"
    "-Dpolkitd_user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "-Dos_type=redhat" # only affects PAM includes
    "-Dintrospection=${lib.boolToString withIntrospection}"
    "-Dtests=${lib.boolToString doCheck}"
    "-Dgtk_doc=${lib.boolToString withIntrospection}"
    "-Dman=true"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-Dsession_tracking=${if useSystemd then "libsystemd-login" else "libelogind"}"
  ];

  # HACK: We want to install policy files files to $out/share but polkit
  # should read them from /run/current-system/sw/share on a NixOS system.
  # Similarly for config files in /etc.
  # With autotools, it was possible to override Make variables
  # at install time but Meson does not support this
  # so we need to convince it to install all files to a temporary
  # location using DESTDIR and then move it to proper one in postInstall.
  env.DESTDIR = "dest";

  inherit doCheck;

  postPatch = ''
    patchShebangs test/polkitbackend/polkitbackendjsauthoritytest-wrapper.py

    # ‘libpolkit-agent-1.so’ should call the setuid wrapper on
    # NixOS.  Hard-coding the path is kinda ugly.  Maybe we can just
    # call through $PATH, but that might have security implications.
    substituteInPlace src/polkitagent/polkitagentsession.c \
      --replace   'PACKAGE_PREFIX "/lib/polkit-1/'   '"${setuid}/'
    substituteInPlace test/data/etc/polkit-1/rules.d/10-testing.rules \
      --replace   /bin/true ${coreutils}/bin/true \
      --replace   /bin/false ${coreutils}/bin/false
  '';

  postConfigure = lib.optionalString doCheck ''
    # Unpacked by meson
    chmod +x subprojects/mocklibc-1.0/bin/mocklibc
    patchShebangs subprojects/mocklibc-1.0/bin/mocklibc
  '';

  checkPhase = ''
    runHook preCheck

    # tests need access to the system bus
    dbus-run-session --config-file=${./system_bus.conf} -- sh -c 'DBUS_SYSTEM_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS meson test --print-errorlogs'

    runHook postCheck
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    # We need to be careful with the ordering to merge without conflicts.
    for o in $(getAllOutputNames); do
        mv "$DESTDIR/''${!o}" "''${!o}"
    done
    mv "$DESTDIR/etc" "$out"
    mv "$DESTDIR${system}/share"/* "$out/share"
    # Ensure we did not forget to install anything.
    rmdir --parents --ignore-fail-on-non-empty "$DESTDIR${builtins.storeDir}" "$DESTDIR${system}/share"
    ! test -e "$DESTDIR"
  '';

  meta = with lib; {
    homepage = "https://github.com/polkit-org/polkit";
    description = "Toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    badPlatforms = [
      # mandatory libpolkit-gobject shared library
      lib.systems.inspect.platformPatterns.isStatic
    ];
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
  };
}
