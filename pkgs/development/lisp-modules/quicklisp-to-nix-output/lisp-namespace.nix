/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lisp-namespace";
  version = "20211020-git";

  description = "Provides LISP-N --- extensible namespaces in Common Lisp.";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lisp-namespace/2021-10-20/lisp-namespace-20211020-git.tgz";
    sha256 = "1vw7zxzhlxqjnas3cxk0f58hxvlvki78vbqsabj6f3n1rq6yx7b7";
  };

  packageName = "lisp-namespace";

  asdFilesToKeep = ["lisp-namespace.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-namespace DESCRIPTION
    Provides LISP-N --- extensible namespaces in Common Lisp. SHA256
    1vw7zxzhlxqjnas3cxk0f58hxvlvki78vbqsabj6f3n1rq6yx7b7 URL
    http://beta.quicklisp.org/archive/lisp-namespace/2021-10-20/lisp-namespace-20211020-git.tgz
    MD5 71d02a1704c93281028316e96ecaead2 NAME lisp-namespace FILENAME
    lisp-namespace DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION 20211020-git SIBLINGS (lisp-namespace.test) PARASITES
    NIL) */
