{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecla";
  version = "1.6.3";

  src = fetchurl {
    url = "https://www.astro.caltech.edu/~mcs/tecla/libtecla-${finalAttrs.version}.tar.gz";
    hash = "sha256-8nV8xVBAhZ/Pj1mgt7JuAYSiK+zkTtlWikU0pHjB7ho=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace install-sh \
      --replace "stripprog=" "stripprog=\$STRIP # "
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = {
    homepage = "https://www.astro.caltech.edu/~mcs/tecla/";
    description = "Command-line editing library";
    longDescription = ''
      The tecla library provides UNIX and LINUX programs with interactive
      command line editing facilities, similar to those of the UNIX tcsh
      shell. In addition to simple command-line editing, it supports recall of
      previously entered command lines, TAB completion of file names or other
      tokens, and in-line wild-card expansion of filenames. The internal
      functions which perform file-name completion and wild-card expansion are
      also available externally for optional use by programs.

      In addition, the library includes a path-searching module. This allows an
      application to provide completion and lookup of files located in UNIX
      style paths. Although not built into the line editor by default, it can
      easily be called from custom tab-completion callback functions. This was
      originally conceived for completing the names of executables and
      providing a way to look up their locations in the user's PATH environment
      variable, but it can easily be asked to look up and complete other types
      of files in any list of directories.

      Note that special care has been taken to allow the use of this library in
      threaded programs. The option to enable this is discussed in the
      Makefile, and specific discussions of thread safety are presented in the
      included man pages.
    '';
    changelog = "https://sites.astro.caltech.edu/~mcs/tecla/release.html";
    license = with lib.licenses; [ mit ];
    mainProgram = "enhance";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
