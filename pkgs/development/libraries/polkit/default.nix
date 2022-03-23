{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, glib
, expat
, pam
, meson
, ninja
, perl
, rsync
, python3
, fetchpatch
, gettext
, spidermonkey_78
, gobject-introspection
, libxslt
, docbook-xsl-nons
, dbus
, docbook_xml_dtd_412
, gtk-doc
, coreutils
, useSystemd ? stdenv.isLinux
, systemd
, elogind
# needed until gobject-introspection does cross-compile (https://github.com/NixOS/nixpkgs/pull/88222)
, withIntrospection ? (stdenv.buildPlatform == stdenv.hostPlatform)
# cross build fails on polkit-1-scan (https://github.com/NixOS/nixpkgs/pull/152704)
, withGtkDoc ? (stdenv.buildPlatform == stdenv.hostPlatform)
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
  version = "0.120";

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  # Tarballs do not contain subprojects.
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "polkit";
    repo = "polkit";
    rev = version;
    sha256 = "oEaRf1g13zKMD+cP1iwIA6jaCDwvNfGy2i8xY8vuVSo=";
  };

  patches = [
    # Allow changing base for paths in pkg-config file as before.
    # https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/100
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/-/commit/7ba07551dfcd4ef9a87b8f0d9eb8b91fabcb41b3.patch";
      sha256 = "ebbLILncq1hAZTBMsLm+vDGw6j0iQ0crGyhzyLZQgKA=";
    })
    # pkexec: local privilege escalation (CVE-2021-4034)
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/-/commit/a2bf5c9c83b6ae46cbd5c779d3055bff81ded683.patch";
      sha256 = "162jkpg2myq0rb0s5k3nfr4pqwv9im13jf6vzj8p5l39nazg5i4s";
    })
    # File descriptor leak allows an unprivileged user to cause a crash (CVE-2021-4115)
    (fetchpatch {
      name = "CVE-2021-4115.patch";
      url = "https://src.fedoraproject.org/rpms/polkit/raw/0a203bd46a1e2ec8cc4b3626840e2ea9d0d13a9a/f/CVE-2021-4115.patch";
      sha256 = "sha256-BivHVVpYB4Ies1YbBDyKwUmNlqq2D1MpMipH9/dZM54=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    # Make netgroup support optional (musl does not have it)
    # Upstream MR: https://gitlab.freedesktop.org/polkit/polkit/merge_requests/10
    # We use the version of the patch that Alpine uses successfully.
    (fetchpatch {
      name = "make-innetgr-optional.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/polkit/make-innetgr-optional.patch?id=424ecbb6e9e3a215c978b58c05e5c112d88dddfc";
      sha256 = "0iyiksqk29sizwaa4623bv683px1fny67639qpb1him89hza00wy";
    })
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
    (python3.withPackages (pp: with pp; [
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
  ];

  buildInputs = [
    expat
    pam
    spidermonkey_78
  ] ++ lib.optionals stdenv.isLinux [
    # On Linux, fall back to elogind when systemd support is off.
    (if useSystemd then systemd else elogind)
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
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
    "-Dintrospection=${lib.boolToString withIntrospection}"
    "-Dtests=${lib.boolToString doCheck}"
    "-Dgtk_doc=${lib.boolToString withGtkDoc}"
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

  postConfigure = ''
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
    platforms = platforms.unix;
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
  };
}
