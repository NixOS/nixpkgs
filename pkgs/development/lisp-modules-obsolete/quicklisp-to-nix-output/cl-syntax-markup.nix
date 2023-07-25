/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-syntax-markup";
  version = "cl-syntax-20150407-git";

  description = "CL-Syntax Reader Syntax for CL-Markup";

  deps = [ args."cl-markup" args."cl-syntax" args."named-readtables" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz";
    sha256 = "1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n";
  };

  packageName = "cl-syntax-markup";

  asdFilesToKeep = ["cl-syntax-markup.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-syntax-markup DESCRIPTION CL-Syntax Reader Syntax for CL-Markup
    SHA256 1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n URL
    http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz
    MD5 602b84143aafe59d65f4e08ac20a124a NAME cl-syntax-markup FILENAME
    cl-syntax-markup DEPS
    ((NAME cl-markup FILENAME cl-markup) (NAME cl-syntax FILENAME cl-syntax)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES (cl-markup cl-syntax named-readtables trivial-types) VERSION
    cl-syntax-20150407-git SIBLINGS
    (cl-syntax-annot cl-syntax-anonfun cl-syntax-clsql
     cl-syntax-fare-quasiquote cl-syntax-interpol cl-syntax)
    PARASITES NIL) */
