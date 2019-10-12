args @ { fetchurl, ... }:
{
  baseName = ''iolib'';
  version = ''v0.8.3'';

  parasites = [ "iolib/multiplex" "iolib/os" "iolib/pathnames" "iolib/sockets" "iolib/streams" "iolib/syscalls" "iolib/trivial-sockets" "iolib/zstreams" ];

  description = ''I/O library.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."idna" args."iolib_dot_asdf" args."iolib_dot_base" args."iolib_dot_common-lisp" args."iolib_dot_conf" args."iolib_dot_grovel" args."split-sequence" args."swap-bytes" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz'';
    sha256 = ''12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c'';
  };

  packageName = "iolib";

  asdFilesToKeep = ["iolib.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib DESCRIPTION I/O library. SHA256
    12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz MD5
    fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib FILENAME iolib DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME idna FILENAME idna)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.base FILENAME iolib_dot_base)
     (NAME iolib.common-lisp FILENAME iolib_dot_common-lisp)
     (NAME iolib.conf FILENAME iolib_dot_conf)
     (NAME iolib.grovel FILENAME iolib_dot_grovel)
     (NAME split-sequence FILENAME split-sequence)
     (NAME swap-bytes FILENAME swap-bytes)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi idna iolib.asdf iolib.base
     iolib.common-lisp iolib.conf iolib.grovel split-sequence swap-bytes
     trivial-features)
    VERSION v0.8.3 SIBLINGS
    (iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples
     iolib.grovel iolib.tests)
    PARASITES
    (iolib/multiplex iolib/os iolib/pathnames iolib/sockets iolib/streams
     iolib/syscalls iolib/trivial-sockets iolib/zstreams)) */
