{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  perl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.7.8";
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
    tag = "version-${finalAttrs.version}";
    hash = "sha256-/Xr2Jl3WbL68ZunBpko7jLbgAbDkERnrtuJnS0m59qY=";
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
})
