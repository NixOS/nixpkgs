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
  xorg,
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

let
  pname = "x2goserver";
  version = "4.1.0.3";

  src = fetchurl {
    url = "https://code.x2go.org/releases/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "Z3aqo1T1pE40nws8F21JiMiKYYwu30bJijeuicBp3NA=";
  };

  x2go-perl = perlPackages.buildPerlPackage {
    pname = "X2Go";
    inherit version src;
    makeFlags = [
      "-f"
      "Makefile.perl"
    ];
    patchPhase = ''
      substituteInPlace X2Go/Config.pm --replace '/etc/x2go' '/var/lib/x2go/conf'
      substituteInPlace X2Go/Server/DB.pm \
        --replace '$x2go_lib_path/libx2go-server-db-sqlite3-wrapper' \
                  '/run/wrappers/bin/x2gosqliteWrapper'
      substituteInPlace X2Go/Server/DB/SQLite3.pm --replace "user='x2gouser'" "user='x2go'"
    '';
  };

  perlEnv = perl.withPackages (
    p: with p; [
      x2go-perl
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

  binaryDeps = [
    perlEnv
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
    xorg.xauth
    xorg.xinit
    xorg.xrandr
    xorg.xmodmap
    xorg.xwininfo
    xorg.fontutil
    xorg.xkbcomp
    xorg.setxkbmap
  ];
in
stdenv.mkDerivation {
  inherit pname version src;

  buildInputs = [
    perlEnv
    bash
  ];

  nativeBuildInputs = [ makeWrapper ];

  prePatch = ''
    patchShebangs .
    sed -i '/Makefile.PL\|Makefile.perl/d' Makefile
    for i in */Makefile; do
      substituteInPlace "$i" --replace "-o root -g root " ""
    done
    substituteInPlace libx2go-server-db-perl/Makefile --replace "chmod 2755" "chmod 755"
    for i in x2goserver/sbin/x2godbadmin x2goserver/bin/x2go*
    do
      substituteInPlace $i --replace '/etc/x2go' '/var/lib/x2go/conf'
    done
    substituteInPlace x2goserver/Makefile \
      --replace-fail "\$(DESTDIR)/etc" "\$(DESTDIR)/\$(ETCDIR)"
    substituteInPlace x2goserver/sbin/x2gocleansessions \
      --replace '/var/run/x2goserver.pid' '/var/run/x2go/x2goserver.pid'
    substituteInPlace x2goserver/sbin/x2godbadmin --replace 'user="x2gouser"' 'user="x2go"'
    substituteInPlace x2goserver-xsession/etc/Xsession \
      --replace "SSH_AGENT /bin/bash -c" "SSH_AGENT ${bash}/bin/bash -c" \
      --replace "[ -f /etc/redhat-release ]" "[ -d /etc/nix ] || [ -f /etc/redhat-release ]"
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
      wrapProgram $i --prefix PATH : ${lib.makeBinPath binaryDeps}:$out
    done
    # We're patching @INC of the setgid wrapper, because we can't mix
    # the perl wrapper (for PERL5LIB) with security.wrappers (for setgid)
    sed -i -e "s,.\+bin/perl,#!${perl}/bin/perl -I ${perlEnv}/lib/perl5/site_perl," \
      $out/lib/x2go/libx2go-server-db-sqlite3-wrapper.pl
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Remote desktop application, server component";
    homepage = "http://x2go.org/";
    platforms = lib.platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ averelld ];
  };
}
