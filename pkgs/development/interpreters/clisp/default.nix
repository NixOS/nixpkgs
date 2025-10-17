# there are the following linking sets:
# - boot (not installed): without modules, only used when building clisp
# - base (default): contains readline and i18n, regexp and syscalls modules
#   by default
# - full: contains base plus modules in withModules
{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  automake,
  bash,
  libtool,
  libsigsegv,
  gettext,
  ncurses,
  pcre,
  zlib,
  readline,
  libffi,
  libffcall,
  libX11,
  libXau,
  libXt,
  libXpm,
  libXext,
  xorgproto,
  coreutils,
  # build options
  threadSupport ? (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.isDarwin),
  x11Support ? (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.isDarwin),
  dllSupport ? true,
  withModules ? [
    "asdf"
    "pcre"
    "rawsock"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "bindings/glibc"
    "zlib"
  ]
  ++ lib.optional x11Support "clx/new-clx",
}:

assert
  x11Support
  -> (
    libX11 != null
    && libXau != null
    && libXt != null
    && libXpm != null
    && xorgproto != null
    && libXext != null
  );

let
  ffcallAvailable = stdenv.hostPlatform.isLinux && (libffcall != null);
in

stdenv.mkDerivation {
  version = "2.49.95-unstable-2024-12-28";
  pname = "clisp";

  src = fetchFromGitLab {
    owner = "gnu-clisp";
    repo = "clisp";
    rev = "c3ec11bab87cfdbeba01523ed88ac2a16b22304d";
    hash = "sha256-xXGx2FlS0l9huVMHqNbcAViLjxK8szOFPT0J8MpGp9w=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    bash
    libsigsegv
  ]
  ++ lib.optional (gettext != null) gettext
  ++ lib.optional (ncurses != null) ncurses
  ++ lib.optional (pcre != null) pcre
  ++ lib.optional (zlib != null) zlib
  ++ lib.optional (readline != null) readline
  ++ lib.optional (ffcallAvailable && (libffi != null)) libffi
  ++ lib.optional ffcallAvailable libffcall
  ++ lib.optionals x11Support [
    libX11
    libXau
    libXt
    libXpm
    xorgproto
    libXext
  ];

  # First, replace port 9090 (rather low, can be used)
  # with 64237 (much higher, IANA private area, not
  # anything rememberable).
  postPatch = ''
    sed -e 's@9090@64237@g' -i tests/socket.tst
    sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
    sed -i 's@1\.16\.2@${automake.version}@' src/aclocal.m4
    find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i
  '';

  configureFlags = [
    "builddir"
  ]
  ++ lib.optional (!dllSupport) "--without-dynamic-modules"
  ++ lib.optional (readline != null) "--with-readline"
  # --with-dynamic-ffi can only exist with --with-ffcall - foreign.d does not compile otherwise
  ++ lib.optional (ffcallAvailable && (libffi != null)) "--with-dynamic-ffi"
  ++ lib.optional ffcallAvailable "--with-ffcall"
  ++ lib.optional (!ffcallAvailable) "--without-ffcall"
  ++ map (x: " --with-module=" + x) withModules
  ++ lib.optional threadSupport "--with-threads=POSIX_THREADS";

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    sed -i -re '/ cfree /d' -i modules/bindings/glibc/linux.lisp
    cd builddir
  '';

  # ;; Loading file ../src/defmacro.lisp ...
  # *** - handle_fault error2 ! address = 0x8 not in [0x1000000c0000,0x1000000c0000) !
  # SIGSEGV cannot be cured. Fault address = 0x8.
  hardeningDisable = [ "pie" ];

  doCheck = true;

  postInstall = lib.optionalString (withModules != [ ]) ''
    bash ./clisp-link add "$out"/lib/clisp*/base "$(dirname "$out"/lib/clisp*/base)"/full \
      ${lib.concatMapStrings (x: " " + x) withModules}

    find "$out"/lib/clisp*/full -type l -name "*.o" | while read -r symlink; do
      if [[ "$(readlink "$symlink")" =~ (.*\/builddir\/)(.*) ]]; then
        ln -sf "../''${BASH_REMATCH[2]}" "$symlink"
      fi
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-O0 -falign-functions=${
    if stdenv.hostPlatform.is64bit then "8" else "4"
  }";

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = "http://clisp.org";
    mainProgram = "clisp";
    teams = [ lib.teams.lisp ];
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
}
