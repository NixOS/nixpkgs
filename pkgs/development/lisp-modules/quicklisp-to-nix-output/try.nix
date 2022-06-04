/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "try";
  version = "20220220-git";

  parasites = [ "try/doc" "try/test" ];

  description = "Try is a test framework.";

  deps = [ args."alexandria" args."cl-ppcre" args."closer-mop" args."ieee-floats" args."mgl-pax" args."mgl-pax_dot_asdf" args."named-readtables" args."pythonic-string-reader" args."trivial-gray-streams" args."try_dot_asdf" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/try/2022-02-20/try-20220220-git.tgz";
    sha256 = "0airdqwram23rczcfas2z2l8liwc4zwg14y972xzgrdi0nlw0xvh";
  };

  packageName = "try";

  asdFilesToKeep = ["try.asd"];
  overrides = x: x;
}
/* (SYSTEM try DESCRIPTION Try is a test framework. SHA256
    0airdqwram23rczcfas2z2l8liwc4zwg14y972xzgrdi0nlw0xvh URL
    http://beta.quicklisp.org/archive/try/2022-02-20/try-20220220-git.tgz MD5
    b871e436d3cc7953d147061de1175a14 NAME try FILENAME try DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closer-mop FILENAME closer-mop)
     (NAME ieee-floats FILENAME ieee-floats) (NAME mgl-pax FILENAME mgl-pax)
     (NAME mgl-pax.asdf FILENAME mgl-pax_dot_asdf)
     (NAME named-readtables FILENAME named-readtables)
     (NAME pythonic-string-reader FILENAME pythonic-string-reader)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME try.asdf FILENAME try_dot_asdf) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria cl-ppcre closer-mop ieee-floats mgl-pax mgl-pax.asdf
     named-readtables pythonic-string-reader trivial-gray-streams try.asdf
     uiop)
    VERSION 20220220-git SIBLINGS (try.asdf) PARASITES (try/doc try/test)) */
