args @ { fetchurl, ... }:
rec {
  baseName = ''lisp-namespace'';
  version = ''20171130-git'';

  description = ''Provides LISP-N --- extensible namespaces in Common Lisp.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lisp-namespace/2017-11-30/lisp-namespace-20171130-git.tgz'';
    sha256 = ''0vxk06c5434kcjv9p414yk23gs4rkibfq695is9y7wglck31fz2j'';
  };

  packageName = "lisp-namespace";

  asdFilesToKeep = ["lisp-namespace.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-namespace DESCRIPTION
    Provides LISP-N --- extensible namespaces in Common Lisp. SHA256
    0vxk06c5434kcjv9p414yk23gs4rkibfq695is9y7wglck31fz2j URL
    http://beta.quicklisp.org/archive/lisp-namespace/2017-11-30/lisp-namespace-20171130-git.tgz
    MD5 d3052a13db167c6a53487f31753b7467 NAME lisp-namespace FILENAME
    lisp-namespace DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION 20171130-git SIBLINGS (lisp-namespace.test) PARASITES
    NIL) */
