{
  lib,
  stdenv,
  fetchurl,
  flex,
  installShellFiles,
  ncurses,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xjobs";
  version = "20250529";

  src = fetchurl {
    url = "mirror://sourceforge//xjobs/files/xjobs-${finalAttrs.version}.tgz";
    hash = "sha256-HR7kqx9N5fn8JMKFK0ierAwrCFlkqKo2S/mxQW9UE44=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace jobctrl.c \
      --replace-fail "#include <stdio.h>" $'#include <stdio.h>\n#include <signal.h>'
  '';

  nativeBuildInputs = [
    flex
    installShellFiles
    which
  ];
  buildInputs = [
    ncurses
  ];

  checkPhase = ''
    runHook preCheck
    ./xjobs -V
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,etc}
    install -m755 xjobs $out/bin/xjobs
    install -m644 xjobs.rc $out/etc/xjobs.rc
    installManPage xjobs.1
    runHook postInstall
  '';

  meta = {
    description = "Program which reads job descriptions line by line and executes them in parallel";
    homepage = "https://www.maier-komor.de/xjobs.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.siriobalmelli ];
    longDescription = ''
      xjobs reads job descriptions line by line and executes them in parallel.

      It limits the number of parallel executing jobs and starts new jobs when jobs finish.

      Therefore, it combines the arguments from every input line with the utility
      and arguments given on the command line.
      If no utility is given as an argument to xjobs,
      then the first argument on every job line will be used as utility.
      To execute utility xjobs searches the directories given in the PATH environment variable
      and uses the first file found in these directories.

      xjobs is most useful on multi-processor/core machines when one needs to execute
      several time consuming command several that could possibly be run in parallel.
      With xjobs this can be achieved easily, and it is possible to limit the load
      of the machine to a useful value.

      It works similar to xargs, but starts several processes simultaneously
      and gives only one line of arguments to each utility call.
    '';
    mainProgram = "xjobs";
  };
})
