/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-inferiors";
  version = "20200325-git";

  description = "A very simple library to use inferior processes.";

  deps = [ args."alexandria" args."bordeaux-threads" args."documentation-utils" args."trivial-indent" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/simple-inferiors/2020-03-25/simple-inferiors-20200325-git.tgz";
    sha256 = "15gjizqrazr0ahdda2l6bkv7ii5ax1wckn9mnj5haiv17jba8pn5";
  };

  packageName = "simple-inferiors";

  asdFilesToKeep = ["simple-inferiors.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-inferiors DESCRIPTION
    A very simple library to use inferior processes. SHA256
    15gjizqrazr0ahdda2l6bkv7ii5ax1wckn9mnj5haiv17jba8pn5 URL
    http://beta.quicklisp.org/archive/simple-inferiors/2020-03-25/simple-inferiors-20200325-git.tgz
    MD5 f90ae807c10d5b3c4b9eef1134a537c8 NAME simple-inferiors FILENAME
    simple-inferiors DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria bordeaux-threads documentation-utils trivial-indent uiop)
    VERSION 20200325-git SIBLINGS NIL PARASITES NIL) */
