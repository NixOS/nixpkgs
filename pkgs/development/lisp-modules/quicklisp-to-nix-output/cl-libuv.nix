args @ { fetchurl, ... }:
rec {
  baseName = ''cl-libuv'';
  version = ''20190107-git'';

  description = ''Low-level libuv bindings for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-libuv/2019-01-07/cl-libuv-20190107-git.tgz'';
    sha256 = ''1cfr29i5j78qy7ax2fs1z4nqyz3kx9121rlpdika12n1zvnhrcm8'';
  };

  packageName = "cl-libuv";

  asdFilesToKeep = ["cl-libuv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp.
    SHA256 1cfr29i5j78qy7ax2fs1z4nqyz3kx9121rlpdika12n1zvnhrcm8 URL
    http://beta.quicklisp.org/archive/cl-libuv/2019-01-07/cl-libuv-20190107-git.tgz
    MD5 c09c505dc45812cc773454ffc6fdbd38 NAME cl-libuv FILENAME cl-libuv DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain trivial-features) VERSION
    20190107-git SIBLINGS NIL PARASITES NIL) */
