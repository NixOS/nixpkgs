{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
  ncurses,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcsh";
  version = "6.24.13";

  src = fetchurl {
    url = "mirror://tcsh/tcsh-${finalAttrs.version}.tar.gz";
    hash = "sha256-HpJ9UunIXRYr+YXyTRPGzO3pvriA2G/sSS7RVIClxxo=";
  };

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libxcrypt
    ncurses
  ];

  passthru.shellPath = "/bin/tcsh";

  meta = {
    homepage = "https://www.tcsh.org/";
    description = "Enhanced version of the Berkeley UNIX C shell (csh)";
    mainProgram = "tcsh";
    longDescription = ''
      tcsh is an enhanced but completely compatible version of the Berkeley UNIX
      C shell, csh. It is a command language interpreter usable both as an
      interactive login shell and a shell script command processor.

      It includes:
      - command-line editor
      - programmable word completion
      - spelling correction
      - history mechanism
      - job control
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ suominen ];
    platforms = lib.platforms.unix;
  };
})
