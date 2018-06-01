args @ { fetchurl, ... }:
rec {
  baseName = ''cl-libuv'';
  version = ''20180328-git'';

  description = ''Low-level libuv bindings for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-libuv/2018-03-28/cl-libuv-20180328-git.tgz'';
    sha256 = ''1pq0fsrhv6aa3fpq1ppwid8nmxaa3fs3dk4iq1bl28prpzzkkg0p'';
  };

  packageName = "cl-libuv";

  asdFilesToKeep = ["cl-libuv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp.
    SHA256 1pq0fsrhv6aa3fpq1ppwid8nmxaa3fs3dk4iq1bl28prpzzkkg0p URL
    http://beta.quicklisp.org/archive/cl-libuv/2018-03-28/cl-libuv-20180328-git.tgz
    MD5 c50f2cca0bd8d25db35b4ec176242858 NAME cl-libuv FILENAME cl-libuv DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain trivial-features) VERSION
    20180328-git SIBLINGS NIL PARASITES NIL) */
