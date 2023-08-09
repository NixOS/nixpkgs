/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iolib";
  version = "v0.8.4";

  parasites = [ "iolib/multiplex" "iolib/os" "iolib/pathnames" "iolib/sockets" "iolib/streams" "iolib/syscalls" "iolib/tests" "iolib/trivial-sockets" "iolib/zstreams" ];

  description = "I/O library.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."fiveam" args."idna" args."iolib_dot_asdf" args."iolib_dot_base" args."iolib_dot_common-lisp" args."iolib_dot_conf" args."split-sequence" args."swap-bytes" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz";
    sha256 = "0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq";
  };

  packageName = "iolib";

  asdFilesToKeep = ["iolib.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib DESCRIPTION I/O library. SHA256
    0vahwswwk3rxkr5wcph5n91sgzlm53d53j8m8sxbqixm8j1ff5vq URL
    http://beta.quicklisp.org/archive/iolib/2021-06-30/iolib-v0.8.4.tgz MD5
    5650165890f8b278b357864f597b377d NAME iolib FILENAME iolib DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME fiveam FILENAME fiveam) (NAME idna FILENAME idna)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.base FILENAME iolib_dot_base)
     (NAME iolib.common-lisp FILENAME iolib_dot_common-lisp)
     (NAME iolib.conf FILENAME iolib_dot_conf)
     (NAME split-sequence FILENAME split-sequence)
     (NAME swap-bytes FILENAME swap-bytes)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain fiveam
     idna iolib.asdf iolib.base iolib.common-lisp iolib.conf split-sequence
     swap-bytes trivial-features)
    VERSION v0.8.4 SIBLINGS
    (iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples)
    PARASITES
    (iolib/multiplex iolib/os iolib/pathnames iolib/sockets iolib/streams
     iolib/syscalls iolib/tests iolib/trivial-sockets iolib/zstreams)) */
