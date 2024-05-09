/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-syntax-anonfun";
  version = "cl-syntax-20150407-git";

  description = "CL-Syntax Reader Syntax for cl-anonfun";

  deps = [ args."cl-anonfun" args."cl-syntax" args."named-readtables" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz";
    sha256 = "1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n";
  };

  packageName = "cl-syntax-anonfun";

  asdFilesToKeep = ["cl-syntax-anonfun.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-syntax-anonfun DESCRIPTION CL-Syntax Reader Syntax for cl-anonfun
    SHA256 1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n URL
    http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz
    MD5 602b84143aafe59d65f4e08ac20a124a NAME cl-syntax-anonfun FILENAME
    cl-syntax-anonfun DEPS
    ((NAME cl-anonfun FILENAME cl-anonfun) (NAME cl-syntax FILENAME cl-syntax)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES (cl-anonfun cl-syntax named-readtables trivial-types) VERSION
    cl-syntax-20150407-git SIBLINGS
    (cl-syntax-annot cl-syntax-clsql cl-syntax-fare-quasiquote
     cl-syntax-interpol cl-syntax-markup cl-syntax)
    PARASITES NIL) */
