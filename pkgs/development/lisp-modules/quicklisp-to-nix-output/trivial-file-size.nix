/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-file-size";
  version = "20200427-git";

  parasites = [ "trivial-file-size/tests" ];

  description = "Stat a file's size.";

  deps = [ args."fiveam" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-file-size/2020-04-27/trivial-file-size-20200427-git.tgz";
    sha256 = "1vspkgygrldbjb4gdm1fsn04j50rwil41x0fvvm4fxm84rwrscsa";
  };

  packageName = "trivial-file-size";

  asdFilesToKeep = ["trivial-file-size.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-file-size DESCRIPTION Stat a file's size. SHA256
    1vspkgygrldbjb4gdm1fsn04j50rwil41x0fvvm4fxm84rwrscsa URL
    http://beta.quicklisp.org/archive/trivial-file-size/2020-04-27/trivial-file-size-20200427-git.tgz
    MD5 1e1952c60c1711869cd6b87b9bc25b52 NAME trivial-file-size FILENAME
    trivial-file-size DEPS
    ((NAME fiveam FILENAME fiveam) (NAME uiop FILENAME uiop)) DEPENDENCIES
    (fiveam uiop) VERSION 20200427-git SIBLINGS NIL PARASITES
    (trivial-file-size/tests)) */
