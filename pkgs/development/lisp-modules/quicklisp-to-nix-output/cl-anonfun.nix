args @ { fetchurl, ... }:
rec {
  baseName = ''cl-anonfun'';
  version = ''20111203-git'';

  description = ''Anonymous function helpers for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-anonfun/2011-12-03/cl-anonfun-20111203-git.tgz'';
    sha256 = ''16r3v3yba41smkqpz0qvzabkxashl39klfb6vxhzbly696x87p1m'';
  };

  packageName = "cl-anonfun";

  asdFilesToKeep = ["cl-anonfun.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-anonfun DESCRIPTION Anonymous function helpers for Common Lisp
    SHA256 16r3v3yba41smkqpz0qvzabkxashl39klfb6vxhzbly696x87p1m URL
    http://beta.quicklisp.org/archive/cl-anonfun/2011-12-03/cl-anonfun-20111203-git.tgz
    MD5 915bda1a7653d42090f8d20a1ad85d0b NAME cl-anonfun FILENAME cl-anonfun
    DEPS NIL DEPENDENCIES NIL VERSION 20111203-git SIBLINGS NIL PARASITES NIL) */
