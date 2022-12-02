{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, glib
, expat
, pam
, meson
, mesonEmulatorHook
, ninja
, perl
, rsync
, python3
, fetchpatch
, gettext
, duktape
, gobject-introspection
, libxslt
, docbook-xsl-nons
, dbus
, docbook_xml_dtd_412
, gtk-doc
, coreutils
, useSystemd ? stdenv.isLinux
, systemdMinimal
, elogind
# A few tests currently fail on musl (polkitunixusertest, polkitunixgrouptest, polkitidentitytest segfault).
# Not yet investigated; it may be due to the "Make netgroup support optional"
# patch not updating the tests correctly yet, or doing something wrong,
# or being unrelated to that.
, doCheck ? (stdenv.isLinux && !stdenv.hostPlatform.isMusl)
}:

let
  system = "/run/current-system/sw";
  setuid = "/run/wrappers/bin";
in
stdenv.mkDerivation rec {
  pname = "polkit";
  version = "121";

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  # Tarballs do not contain subprojects.
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "polkit";
    repo = "polkit";
    rev = version;
    sha256 = "Lj7KSGILc6CBsNqPO0G0PNt6ClikbRG45E8FZbb46yY=";
  };

  patches = [
    # Allow changing base for paths in pkg-config file as before.
    # https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/100
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/-/commit/7ba07551dfcd4ef9a87b8f0d9eb8b91fabcb41b3.patch";
      sha256 = "ebbLILncq1hAZTBMsLm+vDGw6j0iQ0crGyhzyLZQgKA=";
    })
    # Make netgroup support optional (musl does not have it)
    # Upstream MR: https://gitlab.freedesktop.org/polkit/polkit/merge_requests/10
    # NOTE: Remove after the next release
    (fetchpatch {
      name = "make-innetgr-optional.patch";
      url = "https://gitlab.freedesktop.org/polkit/polkit/-/commit/b57deee8178190a7ecc75290fa13cf7daabc2c66.patch";
      sha256 = "8te6gatT9Fp+fIT05fQBym5mEwHeHfaUNUNEMfSbtLc=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    glib
    gtk-doc
    pkg-config
    gettext
    meson
    ninja
    perl
    rsync
    gobject-introspection
    (python3.pythonForBuild.withPackages (pp: with pp; [
      dbus-python
      (python-dbusmock.overridePythonAttrs (attrs: {
        # Avoid dependency cycle.
        doCheck = false;
      }))
    ]))

    # man pages
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_412
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gobject-introspection
    expat
    pam
    dbus
    duktape
  ] ++ lib.optionals stdenv.isLinux [
    # On Linux, fall back to elogind when systemd support is off.
    (if useSystemd then systemdMinimal else elogind)
  ];

  propagatedBuildInputs = [
    glib # in .pc Requires
  ];

  checkInputs = [
    dbus
  ];

  mesonFlags = [
    "--datadir=${system}/share"
    "--sysconfdir=/etc"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dpolkitd_user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "-Dos_type=redhat" # only affects PAM includes
    "-Dtests=${lib.boolToString doCheck}"
    "-Dman=true"
  ] ++ lib.optionals stdenv.isLinux [
    "-Dsession_tracking=${if useSystemd then "libsystemd-login" else "libelogind"}"
  ];

  # HACK: We want to install policy files files to $out/share but polkit
  # should read them from /run/current-system/sw/share on a NixOS system.
  # Similarly for config files in /etc.
  # With autotools, it was possible to override Make variables
  # at install time but Meson does not support this
  # so we need to convince it to install all files to a temporary
  # location using DESTDIR and then move it to proper one in postInstall.
  DESTDIR = "${placeholder "out"}/dest";

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

  postConfigure = lib.optionalString (!stdenv.hostPlatform.isMusl) ''
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
    # We use rsync to merge the directories.
    rsync --archive "${DESTDIR}/etc" "$out"
    rm --recursive "${DESTDIR}/etc"
    rsync --archive "${DESTDIR}${system}"/* "$out"
    rm --recursive "${DESTDIR}${system}"/*
    rmdir --parents --ignore-fail-on-non-empty "${DESTDIR}${system}"
    for o in $outputs; do
        rsync --archive "${DESTDIR}/''${!o}" "$(dirname "''${!o}")"
        rm --recursive "${DESTDIR}/''${!o}"
    done
    # Ensure the DESTDIR is removed.
    destdirContainer="$(dirname "${DESTDIR}")"
    pushd "$destdirContainer"; rmdir --parents "''${DESTDIR##$destdirContainer/}${builtins.storeDir}"; popd
  '';

  meta = with lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/polkit";
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
  };
}
