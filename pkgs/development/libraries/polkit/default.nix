{ lib, stdenv, fetchurl, pkg-config, glib, expat, pam, perl, fetchpatch
, intltool, spidermonkey_78, gobject-introspection, libxslt, docbook_xsl, dbus
, docbook_xml_dtd_412, gtk-doc, coreutils
, useSystemd ? (stdenv.isLinux && !stdenv.hostPlatform.isMusl), systemd, elogind
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
  version = "0.118";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "0swmg37jsxsxfsd2b3qm0l3zxr9ldvhpjw8lsgq3j8q7wy2fjm3d";
  };

  patches = [
    # Don't use etc/dbus-1/system.d
    # Upstream MR: https://gitlab.freedesktop.org/polkit/polkit/merge_requests/11
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/commit/5dd4e22efd05d55833c4634b56e473812b5acbf2.patch";
      sha256 = "17lv7xj5ksa27iv4zpm4zwd4iy8zbwjj4ximslfq3sasiz9kxhlp";
    })
    (fetchpatch {
      # https://www.openwall.com/lists/oss-security/2021/06/03/1
      # https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/79
      name = "CVE-2021-3560.patch";
      url = "https://gitlab.freedesktop.org/polkit/polkit/-/commit/a04d13affe0fa53ff618e07aa8f57f4c0e3b9b81.patch";
      sha256 = "157ddsizgr290jsb8fpafrc37gc1qw5pdvl351vnn3pzhqs7n6f4";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    # Make netgroup support optional (musl does not have it)
    # Upstream MR: https://gitlab.freedesktop.org/polkit/polkit/merge_requests/10
    # We use the version of the patch that Alpine uses successfully.
    (fetchpatch {
      name = "make-innetgr-optional.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/polkit/make-innetgr-optional.patch?id=391e7de6ced1a96c2dac812e0b12f1d7e0ea705e";
      sha256 = "1p9qqqhnrfyjvvd50qh6vpl256kyfblm1qnhz5pm09klrl1bh1n4";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i -e "s/-Wl,--as-needed//" configure.ac
  '';

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  nativeBuildInputs =
    [ glib gtk-doc pkg-config intltool perl ]
    ++ [ libxslt docbook_xsl docbook_xml_dtd_412 ]; # man pages
  buildInputs =
    [ expat pam spidermonkey_78 ]
    # On Linux, fall back to elogind when systemd support is off.
    ++ lib.optional stdenv.isLinux (if useSystemd then systemd else elogind)
    ++ lib.optional withIntrospection gobject-introspection;

  propagatedBuildInputs = [
    glib # in .pc Requires
  ];

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

  configureFlags = [
    "--datadir=${system}/share"
    "--sysconfdir=/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-polkitd-user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "--with-os-type=NixOS" # not recognized but prevents impurities on non-NixOS
    (if withIntrospection then "--enable-introspection" else "--disable-introspection")
  ] ++ lib.optional (!doCheck) "--disable-test";

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "out"}/share/gir-1.0"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  installFlags = [
    "datadir=${placeholder "out"}/share"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  inherit doCheck;
  checkInputs = [ dbus ];
  checkPhase = ''
    # unfortunately this test needs python-dbusmock, but python-dbusmock needs polkit,
    # leading to a circular dependency
    substituteInPlace test/Makefile --replace polkitbackend ""

    # tests need access to the system bus
    dbus-run-session --config-file=${./system_bus.conf} -- sh -c 'DBUS_SYSTEM_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS make check'
  '';

  meta = with lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/polkit";
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = teams.freedesktop.members ++ (with maintainers; [ ]);
  };
}
