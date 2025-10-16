{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "time";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/time/time-${finalAttrs.version}.tar.gz";
    hash = "sha256-+6zwyB5iQp3z4zvaTO44dWYE8Y4B2XczjiMwaj47Uh4=";
  };

  patches = [
    # fixes cross-compilation to riscv64-linux
    ./time-1.9-implicit-func-decl-clang.patch
    # fix compilation with gcc15
    ./c23-fix.patch
  ];

  meta = {
    description = "Tool that runs programs and summarizes the system resources they use";
    longDescription = ''
      The `time' command runs another program, then displays
      information about the resources used by that program, collected
      by the system while the program was running.  You can select
      which information is reported and the format in which it is
      shown, or have `time' save the information in a file instead of
      displaying it on the screen.

      The resources that `time' can report on fall into the general
      categories of time, memory, and I/O and IPC calls.  Some systems
      do not provide much information about program resource use;
      `time' reports unavailable information as zero values.
    '';
    license = lib.licenses.gpl3Plus;
    homepage = "https://www.gnu.org/software/time/";
    platforms = lib.platforms.unix;
    mainProgram = "time";
  };
})
