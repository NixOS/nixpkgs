{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, glib, expat, pam, perl
, intltool, spidermonkey_52 , gobjectIntrospection, libxslt, docbook_xsl, dbus
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


  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s/-Wl,--as-needed//" configure.ac
  '';

  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  nativeBuildInputs =
    [ gtk-doc pkgconfig autoreconfHook intltool gobjectIntrospection perl ]
    ++ [ libxslt docbook_xsl docbook_xml_dtd_412 ]; # man pages
  buildInputs =
    [ glib expat pam spidermonkey_52 gobjectIntrospection ]
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

  # The following is required on grsecurity/PaX due to spidermonkey's JIT
  postBuild = stdenv.lib.optionalString stdenv.isLinux ''
    paxmark mr src/polkitbackend/.libs/polkitd
  '' + stdenv.lib.optionalString (stdenv.isLinux && doCheck) ''
    paxmark mr test/polkitbackend/.libs/polkitbackendjsauthoritytest
  '';

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
