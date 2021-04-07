/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-utf-8";
  version = "20200925-git";

  parasites = [ "trivial-utf-8/doc" "trivial-utf-8/tests" ];

  description = "A small library for doing UTF-8-based input and output.";

  deps = [ args."mgl-pax" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-utf-8/2020-09-25/trivial-utf-8-20200925-git.tgz";
    sha256 = "06v9jif4f5xyl5jd7ldg69ds7cypf72xl7nda5q55fssmgcydi1b";
  };

  packageName = "trivial-utf-8";

  asdFilesToKeep = ["trivial-utf-8.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-utf-8 DESCRIPTION
    A small library for doing UTF-8-based input and output. SHA256
    06v9jif4f5xyl5jd7ldg69ds7cypf72xl7nda5q55fssmgcydi1b URL
    http://beta.quicklisp.org/archive/trivial-utf-8/2020-09-25/trivial-utf-8-20200925-git.tgz
    MD5 799ece1f87cc4a83e81e598bc6b1dd1d NAME trivial-utf-8 FILENAME
    trivial-utf-8 DEPS ((NAME mgl-pax FILENAME mgl-pax)) DEPENDENCIES (mgl-pax)
    VERSION 20200925-git SIBLINGS NIL PARASITES
    (trivial-utf-8/doc trivial-utf-8/tests)) */
