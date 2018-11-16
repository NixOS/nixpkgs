args @ { fetchurl, ... }:
rec {
  baseName = ''cl-libuv'';
  version = ''20180831-git'';

  description = ''Low-level libuv bindings for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-libuv/2018-08-31/cl-libuv-20180831-git.tgz'';
    sha256 = ''1dxay9vw0wmlmwjq5xcs622n4m7g9ivfr46z1igdrkfqvmdz411f'';
  };

  packageName = "cl-libuv";

  asdFilesToKeep = ["cl-libuv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp.
    SHA256 1dxay9vw0wmlmwjq5xcs622n4m7g9ivfr46z1igdrkfqvmdz411f URL
    http://beta.quicklisp.org/archive/cl-libuv/2018-08-31/cl-libuv-20180831-git.tgz
    MD5 d755a060faac0d50a4500ae1628401ce NAME cl-libuv FILENAME cl-libuv DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain trivial-features) VERSION
    20180831-git SIBLINGS NIL PARASITES NIL) */
