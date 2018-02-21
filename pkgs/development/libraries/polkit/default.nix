{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, glib, expat, pam
, intltool, spidermonkey_17 , gobjectIntrospection, libxslt, docbook_xsl
, docbook_xml_dtd_412, gtk_doc
, useSystemd ? stdenv.isLinux, systemd
}:

let

  system = "/var/run/current-system/sw";
  setuid = "/run/wrappers/bin"; #TODO: from <nixos> config.security.wrapperDir;

  foolVars = {
    SYSCONF = "/etc";
    DATA = "${system}/share"; # to find share/polkit-1/actions of other apps at runtime
  };

in

stdenv.mkDerivation rec {
  name = "polkit-0.113";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/polkit/releases/${name}.tar.gz";
    sha256 = "109w86kfqrgz83g9ivggplmgc77rz8kx8646izvm2jb57h4rbh71";
  };

  patches = [
    (fetchpatch {
      url = "http://src.fedoraproject.org/cgit/rpms/polkit.git/plain/polkit-0.113-agent-leaks.patch?id=fa6fd575804de92886c95d3bc2b7eb2abcd13760";
      sha256 = "1cxnhj0y30g7ldqq1y6zwsbdwcx7h97d3mpd3h5jy7dhg3h9ym91";
    })
    (fetchpatch {
      url = "http://src.fedoraproject.org/cgit/rpms/polkit.git/plain/polkit-0.113-polkitpermission-leak.patch?id=fa6fd575804de92886c95d3bc2b7eb2abcd13760";
      sha256 = "1h1rkd4avqyyr8q6836zzr3w10jf521gcqnvhrhzwdpgp1ay4si7";
    })
    (fetchpatch {
      url = "http://src.fedoraproject.org/cgit/rpms/polkit.git/plain/polkit-0.113-itstool.patch?id=fa6fd575804de92886c95d3bc2b7eb2abcd13760";
      sha256 = "0bxmjwp8ahy1y5g1l0kxmld0l3mlvb2l0i5n1qabia3d5iyjkyfh";
    })
  ]
  # Could be applied uncondtionally but don't want to trigger rebuild
  # https://bugs.freedesktop.org/show_bug.cgi?id=50145
  ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
    name = "netgroup-optional.patch";
    url = "https://bugs.freedesktop.org/attachment.cgi?id=118753";
    sha256 = "1zq51dhmqi9zi86bj9dq4i4pxlxm41k3k4a091j07bd78cjba038";
  });


  outputs = [ "bin" "dev" "out" ]; # small man pages in $bin

  nativeBuildInputs =
    [ gtk_doc pkgconfig autoreconfHook intltool gobjectIntrospection ]
    ++ [ libxslt docbook_xsl docbook_xml_dtd_412 ]; # man pages
  buildInputs =
    [ glib expat pam spidermonkey_17 gobjectIntrospection ]
    ++ stdenv.lib.optional useSystemd systemd;

  # Ugly hack to overwrite hardcoded directories
  # TODO: investigate a proper patch which will be accepted upstream
  # After update it's good to check the sources via:
  #   grep '\<PACKAGE_' '--include=*.[ch]' -R
  CFLAGS = stdenv.lib.concatStringsSep " "
    ( map (var: ''-DPACKAGE_${var}_DIR=\""${builtins.getAttr var foolVars}"\"'')
        (builtins.attrNames foolVars) );

  preConfigure = ''
    patchShebangs .
  '' + stdenv.lib.optionalString useSystemd /* bogus chroot detection */ ''
    sed '/libsystemd autoconfigured/s/.*/:/' -i configure
  ''
    # ‘libpolkit-agent-1.so’ should call the setuid wrapper on
    # NixOS.  Hard-coding the path is kinda ugly.  Maybe we can just
    # call through $PATH, but that might have security implications.
  + ''
    substituteInPlace src/polkitagent/polkitagentsession.c \
      --replace   'PACKAGE_PREFIX "/lib/polkit-1/'   '"${setuid}/'
  '';

  configureFlags = [
    #"--libexecdir=$(out)/libexec/polkit-1" # this and localstatedir are ignored by configure
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-polkitd-user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "--with-os-type=NixOS" # not recognized but prevents impurities on non-NixOS
    "--enable-introspection"
  ];

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0 INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  # The following is required on grsecurity/PaX due to spidermonkey's JIT
  postBuild = ''
    paxmark mr src/polkitbackend/.libs/polkitd
    paxmark mr test/polkitbackend/.libs/polkitbackendjsauthoritytest
  '';

  #doCheck = true; # some /bin/bash problem that isn't auto-solved by patchShebangs

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/polkit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
