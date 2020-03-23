args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20191130-git'';

  parasites = [ "clx/test" ];

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2019-11-30/clx-20191130-git.tgz'';
    sha256 = ''1fyh34hrx4p4kf5mijrmgl66hy7yjh9y43ilxck5q378291yk8dj'';
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    1fyh34hrx4p4kf5mijrmgl66hy7yjh9y43ilxck5q378291yk8dj URL
    http://beta.quicklisp.org/archive/clx/2019-11-30/clx-20191130-git.tgz MD5
    61e86a60727732df62c9fa383535fc89 NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20191130-git
    SIBLINGS NIL PARASITES (clx/test)) */
