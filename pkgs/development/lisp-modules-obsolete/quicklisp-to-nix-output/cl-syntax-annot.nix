/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-syntax-annot";
  version = "cl-syntax-20150407-git";

  description = "CL-Syntax Reader Syntax for cl-annot";

  deps = [ args."alexandria" args."cl-annot" args."cl-syntax" args."named-readtables" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz";
    sha256 = "1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n";
  };

  packageName = "cl-syntax-annot";

  asdFilesToKeep = ["cl-syntax-annot.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-syntax-annot DESCRIPTION CL-Syntax Reader Syntax for cl-annot
    SHA256 1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n URL
    http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz
    MD5 602b84143aafe59d65f4e08ac20a124a NAME cl-syntax-annot FILENAME
    cl-syntax-annot DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES (alexandria cl-annot cl-syntax named-readtables trivial-types)
    VERSION cl-syntax-20150407-git SIBLINGS
    (cl-syntax-anonfun cl-syntax-clsql cl-syntax-fare-quasiquote
     cl-syntax-interpol cl-syntax-markup cl-syntax)
    PARASITES NIL) */
