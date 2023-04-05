/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-libuv";
  version = "20200610-git";

  description = "Low-level libuv bindings for Common Lisp.";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-libuv/2020-06-10/cl-libuv-20200610-git.tgz";
    sha256 = "1ywk1z1ibyk3z0irg5azjrjk3x08ixv30fx4qa0p500fmbfhha19";
  };

  packageName = "cl-libuv";

  asdFilesToKeep = ["cl-libuv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp.
    SHA256 1ywk1z1ibyk3z0irg5azjrjk3x08ixv30fx4qa0p500fmbfhha19 URL
    http://beta.quicklisp.org/archive/cl-libuv/2020-06-10/cl-libuv-20200610-git.tgz
    MD5 e6b3f8ffa7b8fb642350f09d1afa7f38 NAME cl-libuv FILENAME cl-libuv DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain trivial-features) VERSION
    20200610-git SIBLINGS NIL PARASITES NIL) */
