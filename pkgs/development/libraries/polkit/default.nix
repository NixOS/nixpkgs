{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, expat
, pam
, perl
, fetchpatch
, intltool
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
  version = "0.119";

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "0p0zzmr0kh3mpmqya4q27y4h9b920zp5ya0i8909ahp9hvdrymy8";
  };

  patches = [
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
    intltool
    perl

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

  configureFlags = [
    "--datadir=${system}/share"
    "--sysconfdir=/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-polkitd-user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "--with-os-type=NixOS" # not recognized but prevents impurities on non-NixOS
    (if withIntrospection then "--enable-introspection" else "--disable-introspection")
  ] ++ lib.optionals (!doCheck) [
    "--disable-test"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "out"}/share/gir-1.0"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  installFlags = [
    "datadir=${placeholder "out"}/share"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  inherit doCheck;

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i -e "s/-Wl,--as-needed//" configure.ac
  '';

  preConfigure = ''
    chmod +x test/mocklibc/bin/mocklibc{,-test}.in
    patchShebangs .

    # ‘libpolkit-agent-1.so’ should call the setuid wrapper on
    # NixOS.  Hard-coding the path is kinda ugly.  Maybe we can just
    # call through $PATH, but that might have security implications.
    substituteInPlace src/polkitagent/polkitagentsession.c \
      --replace   'PACKAGE_PREFIX "/lib/polkit-1/'   '"${setuid}/'
    substituteInPlace test/data/etc/polkit-1/rules.d/10-testing.rules \
      --replace   /bin/true ${coreutils}/bin/true \
      --replace   /bin/false ${coreutils}/bin/false

  '' + lib.optionalString useSystemd /* bogus chroot detection */ ''
    sed '/libsystemd autoconfigured/s/.*/:/' -i configure
  '';

  checkPhase = ''
    runHook preCheck

    # unfortunately this test needs python-dbusmock, but python-dbusmock needs polkit,
    # leading to a circular dependency
    substituteInPlace test/Makefile --replace polkitbackend ""

    # tests need access to the system bus
    dbus-run-session --config-file=${./system_bus.conf} -- sh -c 'DBUS_SYSTEM_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS make check'

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/polkit";
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
  };
}
