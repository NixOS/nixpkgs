{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, glib, expat, pam, perl
, intltool, spidermonkey_52 , gobject-introspection, libxslt, docbook_xsl, dbus
, docbook_xml_dtd_412, gtk-doc, coreutils
, useSystemd ? stdenv.isLinux, systemd
, doCheck ? stdenv.isLinux
}:

let

  system = "/run/current-system/sw";
  setuid = "/run/wrappers/bin"; #TODO: from <nixos> config.security.wrapperDir;

in

stdenv.mkDerivation rec {
  name = "polkit-0.115";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/polkit/releases/${name}.tar.gz";
    sha256 = "0c91y61y4gy6p91cwbzg32dhavw4b7fflg370rimqhdxpzdfr1rg";
  };

  patches = [
    # CVE-2019-6133 - See: https://bugs.chromium.org/p/project-zero/issues/detail?id=1692
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/commit/6cc6aafee135ba44ea748250d7d29b562ca190e3.patch";
      name = "CVE-2019-6133.patch";
      sha256 = "0jjlbjzqcz96xh6w3nv3ss9jl0hhrcd7jg4aa5advf08ibaj29r1";
    })
    # CVE-2018-19788 - high UID fixup
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/commit/5230646dc6876ef6e27f57926b1bad348f636147.patch";
      name = "CVE-2018-19788.patch";
      sha256 = "1y3az4mlxx8k1zcss5qm7k102s7k1kqgcfnf11j9678fh7p008vp";
    })
  ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s/-Wl,--as-needed//" configure.ac
  '';

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  nativeBuildInputs =
    [ gtk-doc pkgconfig autoreconfHook intltool gobject-introspection perl ]
    ++ [ libxslt docbook_xsl docbook_xml_dtd_412 ]; # man pages
  buildInputs =
    [ glib expat pam spidermonkey_52 gobject-introspection ]
    ++ stdenv.lib.optional useSystemd systemd;

  NIX_CFLAGS_COMPILE = " -Wno-deprecated-declarations "; # for polkit 0.114 and glib 2.56

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

  '' + stdenv.lib.optionalString useSystemd /* bogus chroot detection */ ''
    sed '/libsystemd autoconfigured/s/.*/:/' -i configure
  '';

  configureFlags = [
    "--datadir=${system}/share"
    "--sysconfdir=/etc"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-polkitd-user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "--with-os-type=NixOS" # not recognized but prevents impurities on non-NixOS
    "--enable-introspection"
  ] ++ stdenv.lib.optional (!doCheck) "--disable-test";

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0 INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  installFlags=["datadir=$(out)/share" "sysconfdir=$(out)/etc"];

  inherit doCheck;
  checkInputs = [dbus];
  checkPhase = ''
    # tests need access to the system bus
    dbus-run-session --config-file=${./system_bus.conf} -- sh -c 'DBUS_SYSTEM_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS make check'
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/polkit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
