/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "optima";
  version = "20150709-git";

  description = "Optimized Pattern Matching Library";

  deps = [ args."alexandria" args."closer-mop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/optima/2015-07-09/optima-20150709-git.tgz";
    sha256 = "0vqyqrnx2d8qwa2jlg9l2wn6vrykraj8a1ysz0gxxxnwpqc29hdc";
  };

  packageName = "optima";

  asdFilesToKeep = ["optima.asd"];
  overrides = x: x;
}
/* (SYSTEM optima DESCRIPTION Optimized Pattern Matching Library SHA256
    0vqyqrnx2d8qwa2jlg9l2wn6vrykraj8a1ysz0gxxxnwpqc29hdc URL
    http://beta.quicklisp.org/archive/optima/2015-07-09/optima-20150709-git.tgz
    MD5 20523dc3dfc04bb2526008dff0842caa NAME optima FILENAME optima DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop))
    DEPENDENCIES (alexandria closer-mop) VERSION 20150709-git SIBLINGS
    (optima.ppcre optima.test) PARASITES NIL) */
