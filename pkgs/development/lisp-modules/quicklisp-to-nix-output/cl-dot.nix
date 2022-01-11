/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-dot";
  version = "20200925-git";

  description = "Generate Dot Output from Arbitrary Lisp Data";

  deps = [ args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dot/2020-09-25/cl-dot-20200925-git.tgz";
    sha256 = "01vx4yzasmgswrlyagjr2cz76g906jsijdwikdf8wvxyyq77gkla";
  };

  packageName = "cl-dot";

  asdFilesToKeep = ["cl-dot.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-dot DESCRIPTION Generate Dot Output from Arbitrary Lisp Data
    SHA256 01vx4yzasmgswrlyagjr2cz76g906jsijdwikdf8wvxyyq77gkla URL
    http://beta.quicklisp.org/archive/cl-dot/2020-09-25/cl-dot-20200925-git.tgz
    MD5 35c68f431f188d4c1c7604b4b1af220f NAME cl-dot FILENAME cl-dot DEPS
    ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop) VERSION 20200925-git
    SIBLINGS NIL PARASITES NIL) */
