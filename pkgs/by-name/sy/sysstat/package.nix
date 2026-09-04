{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysstat";
  version = "12.8.0";

  src = fetchFromGitHub {
    owner = "sysstat";
    repo = "sysstat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iBGxggoA6x0VYWgF0QiPnmyjyTSetA1BZwFRBU55s4I=";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    export BZIP=${bzip2.bin}/bin/bzip2
    export SYSTEMCTL=systemctl
    export COMPRESS_MANPG=n
  '';

  makeFlags = [
    "SYSCONFIG_DIR=$(out)/etc"
    "IGNORE_FILE_ATTRIBUTES=y"
    "CHOWN=true"
  ];
  installTargets = [
    "install_base"
    "install_nls"
    "install_man"
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ];

  patches = [ ./install.patch ];

  meta = {
    mainProgram = "iostat";
    homepage = "https://sysstat.github.io/";
    description = "Collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.hensoko ];
  };
})
