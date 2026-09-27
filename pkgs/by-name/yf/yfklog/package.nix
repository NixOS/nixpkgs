{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yfklog";
  version = "0.7.0";

  src = fetchurl {
    url = "https://fkurz.net/ham/yfklog/yfklog-${finalAttrs.version}.tar.gz";
    hash = "sha256-P18Iq7bPgC/zndPjyAsPQ0jO6I0H2Bi9MttRvYQNFmg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [
    (perl.withPackages (
      ps: with ps; [
        Curses
        DBDSQLite
        DBI
        IOSocketTimeout
        NetTelnet
        libwwwperl
      ]
    ))
  ];

  #in upstream Makefile DESTDIR only need during installation
  installFlags = [ "DESTDIR=$(out)" ];

  #yfksubs.pl is installed as non-executable
  postInstall = ''
    chmod +x $out/share/yfklog/yfksubs.pl
    patchShebangs $out/share/yfklog/yfksubs.pl
    chmod 044 $out/share/yfklog/yfksubs.pl
  '';

  meta = {
    description = "General purpose ham radio logbook";
    homepage = "https://fkurz.net/ham/yfklog.html";
    changelog = "https://fkurz.net/ham/yfklog/CHANGELOG";
    mainProgram = "yfk";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ castorNova2 ];
    platforms = lib.platforms.unix;
  };
})
