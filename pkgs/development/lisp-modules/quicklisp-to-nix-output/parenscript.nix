args @ { fetchurl, ... }:
rec {
  baseName = ''parenscript'';
  version = ''Parenscript-2.6'';

  description = ''Lisp to JavaScript transpiler'';

  deps = [ args."anaphora" args."cl-ppcre" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/parenscript/2016-03-18/Parenscript-2.6.tgz'';
    sha256 = ''1hvr407fz7gzaxqbnki4k3l44qvl7vk6p5pn7811nrv6lk3kp5li'';
  };

  packageName = "parenscript";

  asdFilesToKeep = ["parenscript.asd"];
  overrides = x: x;
}
/* (SYSTEM parenscript DESCRIPTION Lisp to JavaScript transpiler SHA256
    1hvr407fz7gzaxqbnki4k3l44qvl7vk6p5pn7811nrv6lk3kp5li URL
    http://beta.quicklisp.org/archive/parenscript/2016-03-18/Parenscript-2.6.tgz
    MD5 dadecc13f2918bc618fb143e893deb99 NAME parenscript FILENAME parenscript
    DEPS
    ((NAME anaphora FILENAME anaphora) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (anaphora cl-ppcre named-readtables) VERSION Parenscript-2.6
    SIBLINGS (parenscript.test) PARASITES NIL) */
