args @ { fetchurl, ... }:
rec {
  baseName = ''cl-libuv'';
  version = ''20160825-git'';

  description = ''Low-level libuv bindings for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-libuv/2016-08-25/cl-libuv-20160825-git.tgz'';
    sha256 = ''02vi9ph9pxbxgp9jsbgzb9nijsv0vyk3f1jyhhm88i0y1kb3595r'';
  };

  packageName = "cl-libuv";

  asdFilesToKeep = ["cl-libuv.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp.
    SHA256 02vi9ph9pxbxgp9jsbgzb9nijsv0vyk3f1jyhhm88i0y1kb3595r URL
    http://beta.quicklisp.org/archive/cl-libuv/2016-08-25/cl-libuv-20160825-git.tgz
    MD5 ba5e3cfaadcf710eaee67cc9e716e45a NAME cl-libuv FILENAME cl-libuv DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi cffi-grovel trivial-features) VERSION
    20160825-git SIBLINGS NIL PARASITES NIL) */
