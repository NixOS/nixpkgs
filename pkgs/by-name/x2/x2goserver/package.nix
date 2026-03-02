{
  stdenv,
  lib,
  fetchurl,
  perlPackages,
  makeWrapper,
  perl,
  which,
  nx-libs,
  util-linux,
  coreutils,
  glibc,
  gawk,
  gnused,
  gnugrep,
  findutils,
  font-util,
  xwininfo,
  xrandr,
  xmodmap,
  xkbcomp,
  xinit,
  xauth,
  setxkbmap,
  net-tools,
  iproute2,
  bc,
  procps,
  psmisc,
  lsof,
  pwgen,
  openssh,
  sshfs,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x2goserver";
  version = "4.1.0.5";

  src = fetchurl {
    url = "https://code.x2go.org/releases/source/x2goserver/x2goserver-${finalAttrs.version}.tar.gz";
    hash = "sha256-Q1vbB84iQZ2eRWDf+Kyn+utrNgkdVayrwXZCm5Ia65Y=";
  };

  buildInputs = [
    finalAttrs.passthru.perlEnv
    bash
  ];

  nativeBuildInputs = [ makeWrapper ];

  prePatch = ''
    patchShebangs .
    sed -i '/Makefile.PL\|Makefile.perl/d' Makefile
    substituteInPlace */Makefile \
      --replace-fail '-o root -g root ' ""
    substituteInPlace libx2go-server-db-perl/Makefile \
      --replace-fail 'chmod 2755' 'chmod 755'
    # --replace without fail because not all x2go binaries use '/etc/x2go'
    substituteInPlace x2goserver/{s,}bin/x2go* \
      --replace '/etc/x2go' '/var/lib/x2go/conf'
    substituteInPlace x2goserver/Makefile \
      --replace-fail "\$(DESTDIR)/etc" "\$(DESTDIR)/\$(ETCDIR)"
    substituteInPlace x2goserver/sbin/x2gocleansessions \
      --replace-fail '/var/run/x2goserver.pid' '/var/run/x2go/x2goserver.pid'
    substituteInPlace x2goserver/sbin/x2godbadmin \
      --replace-fail 'user="x2gouser"' 'user="x2go"'
    substituteInPlace x2goserver-xsession/etc/Xsession \
      --replace-fail 'SSH_AGENT /bin/bash -c' 'SSH_AGENT ${bash}/bin/bash -c' \
      --replace-fail '[ -f /etc/redhat-release ]' '[ -d /etc/nix ] || [ -f /etc/redhat-release ]'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc/x2go"
    "NXLIBDIR=${placeholder "out"}"
  ];

  postInstall = ''
    mv $out/etc/x2go/x2goserver.conf{,.example}
    mv $out/etc/x2go/x2goagent.options{,.example}
    ln -sf ${nx-libs}/bin/nxagent $out/bin/x2goagent
    ln -sf ${nx-libs}/share/nx/VERSION.nxagent $out/share/x2go/versions/VERSION.x2goserver-x2goagent
    for i in $out/sbin/x2go* $(find $out/bin -type f) \
      $(ls $out/lib/x2go/x2go* | grep -v x2gocheckport)
    do
      wrapProgram $i --prefix PATH : ${
        lib.makeBinPath [
          finalAttrs.passthru.perlEnv
          which
          nx-libs
          util-linux
          coreutils
          glibc.bin
          gawk
          gnused
          gnugrep
          findutils
          net-tools
          iproute2
          bc
          procps
          psmisc
          lsof
          pwgen
          openssh
          sshfs
          xauth
          xinit
          xrandr
          xmodmap
          xwininfo
          font-util
          xkbcomp
          setxkbmap
        ]
      }:$out
    done
    # We're patching @INC of the setgid wrapper, because we can't mix
    # the perl wrapper (for PERL5LIB) with security.wrappers (for setgid)
    sed -i -e "s,.\+bin/perl,#!${perl}/bin/perl -I ${finalAttrs.passthru.perlEnv}/lib/perl5/site_perl," \
      $out/lib/x2go/libx2go-server-db-sqlite3-wrapper.pl
  '';

  enableParallelBuilding = true;

  passthru = {
    # x2go-perl in passthru, so it can depend on finalAttrs (thus overriding works)
    x2go-perl = perlPackages.buildPerlPackage {
      pname = "x2go-perl";
      inherit (finalAttrs) version src;

      patchPhase = ''
        runHook prePatch

        substituteInPlace X2Go/Config.pm \
          --replace-fail '/etc/x2go' '/var/lib/x2go/conf'
        substituteInPlace X2Go/Server/DB.pm \
          --replace-fail '$x2go_lib_path/libx2go-server-db-sqlite3-wrapper' '/run/wrappers/bin/x2gosqliteWrapper'
        substituteInPlace X2Go/Server/DB/SQLite3.pm \
          --replace-fail "user='x2gouser'" "user='x2go'"

        runHook postPatch
      '';

      makeFlags = [
        "-f"
        "Makefile.perl"
      ];

      inherit (finalAttrs) meta;
    };

    perlEnv = perl.withPackages (
      p: with p; [
        finalAttrs.passthru.x2go-perl
        DBI
        DBDSQLite
        FileBaseDir
        TryTiny
        CaptureTiny
        ConfigSimple
        Switch
        FileWhich
      ]
    );
  };

  meta = {
    description = "Remote desktop application, server component";
    homepage = "http://x2go.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ averelld ];
  };
})
