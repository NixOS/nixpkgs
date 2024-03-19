/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "varjo";
  version = "release-quicklisp-92f9c75b-git";

  description = "Common Lisp -> GLSL Compiler";

  deps = [ args."alexandria" args."cl-ppcre" args."documentation-utils" args."fn" args."glsl-docs" args."glsl-spec" args."glsl-symbols" args."named-readtables" args."parse-float" args."trivial-indent" args."uiop" args."vas-string-metrics" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/varjo/2021-01-24/varjo-release-quicklisp-92f9c75b-git.tgz";
    sha256 = "0xxi2ivjz3fqgw2nxzshf9m7ppvzv7wdg20lr0krq14i8j5gf5jy";
  };

  packageName = "varjo";

  asdFilesToKeep = ["varjo.asd"];
  overrides = x: x;
}
/* (SYSTEM varjo DESCRIPTION Common Lisp -> GLSL Compiler SHA256
    0xxi2ivjz3fqgw2nxzshf9m7ppvzv7wdg20lr0krq14i8j5gf5jy URL
    http://beta.quicklisp.org/archive/varjo/2021-01-24/varjo-release-quicklisp-92f9c75b-git.tgz
    MD5 78a3b8021885ebfab4015e20b885cdcf NAME varjo FILENAME varjo DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME fn FILENAME fn) (NAME glsl-docs FILENAME glsl-docs)
     (NAME glsl-spec FILENAME glsl-spec)
     (NAME glsl-symbols FILENAME glsl-symbols)
     (NAME named-readtables FILENAME named-readtables)
     (NAME parse-float FILENAME parse-float)
     (NAME trivial-indent FILENAME trivial-indent) (NAME uiop FILENAME uiop)
     (NAME vas-string-metrics FILENAME vas-string-metrics))
    DEPENDENCIES
    (alexandria cl-ppcre documentation-utils fn glsl-docs glsl-spec
     glsl-symbols named-readtables parse-float trivial-indent uiop
     vas-string-metrics)
    VERSION release-quicklisp-92f9c75b-git SIBLINGS (varjo.import varjo.tests)
    PARASITES NIL) */
