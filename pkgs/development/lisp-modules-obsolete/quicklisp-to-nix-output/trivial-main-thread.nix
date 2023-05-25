/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-main-thread";
  version = "20190710-git";

  description = "Compatibility library to run things in the main thread.";

  deps = [ args."alexandria" args."array-utils" args."bordeaux-threads" args."dissect" args."simple-tasks" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-main-thread/2019-07-10/trivial-main-thread-20190710-git.tgz";
    sha256 = "1zj12rc29rrff5grmi7sjxfzdv78khbb4sg43hy2cb33hykpvg2h";
  };

  packageName = "trivial-main-thread";

  asdFilesToKeep = ["trivial-main-thread.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-main-thread DESCRIPTION
    Compatibility library to run things in the main thread. SHA256
    1zj12rc29rrff5grmi7sjxfzdv78khbb4sg43hy2cb33hykpvg2h URL
    http://beta.quicklisp.org/archive/trivial-main-thread/2019-07-10/trivial-main-thread-20190710-git.tgz
    MD5 ab95906f1831aa5b40f271eebdfe11a3 NAME trivial-main-thread FILENAME
    trivial-main-thread DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME array-utils FILENAME array-utils)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect) (NAME simple-tasks FILENAME simple-tasks)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria array-utils bordeaux-threads dissect simple-tasks
     trivial-features)
    VERSION 20190710-git SIBLINGS NIL PARASITES NIL) */
