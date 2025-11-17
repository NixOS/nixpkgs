{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  perl,
  buildPackages,
}:

stdenv.mkDerivation {
  version = "3.7.7";
  pname = "taktuk";

  nativeBuildInputs = [
    autoreconfHook
    perl # pod2man pod2html
  ];

  buildInputs = [ perl ];

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "taktuk";
    repo = "taktuk";
    rev = "dcd763e389a414f540b43674cbc63752176f1ce3"; # does not tag releases
    hash = "sha256-CerOBn1VDiKFLaW2WXv6wLxfcqy1H3dlF70lrequbog=";
  };

  preBuild = ''
    substituteInPlace ./taktuk --replace-fail "/usr/bin/perl" "${lib.getExe buildPackages.perl}"
  '';

  enableParallelBuilding = true;

  preFixup = ''
    substituteInPlace ./taktuk --replace-fail "${lib.getExe buildPackages.perl}" "/usr/bin/env perl"
  '';

  meta = {
    description = "Efficient, large scale, parallel remote execution of commands";
    mainProgram = "taktuk";
    longDescription = ''
      TakTuk allows one to execute commands in parallel on a potentially large set
      of remote nodes (using ssh to connect to each node). It is typically used
      inside high performance computing clusters and grids. It uses an adaptive
      algorithm to efficiently distribute the work and sets up an interconnection
      network to transport commands and perform I/Os multiplexing. It doesn't
      require any specific software on the nodes thanks to a self-propagation
      algorithm.'';
    homepage = "https://taktuk.gitlabpages.inria.fr/";
    changelog = "https://gitlab.inria.fr/taktuk/taktuk/-/blob/HEAD/ChangeLog";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}
