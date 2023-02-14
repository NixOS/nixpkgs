/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fiveam";
  version = "20220220-git";

  parasites = [ "fiveam/test" ];

  description = "A simple regression testing framework";

  deps = [ args."alexandria" args."net_dot_didierverna_dot_asdf-flv" args."trivial-backtrace" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fiveam/2022-02-20/fiveam-20220220-git.tgz";
    sha256 = "0saj55a1kj1dg11f2fgc7dlq8pm40rx8kbsvbn6q4705l1f3an34";
  };

  packageName = "fiveam";

  asdFilesToKeep = ["fiveam.asd"];
  overrides = x: x;
}
/* (SYSTEM fiveam DESCRIPTION A simple regression testing framework SHA256
    0saj55a1kj1dg11f2fgc7dlq8pm40rx8kbsvbn6q4705l1f3an34 URL
    http://beta.quicklisp.org/archive/fiveam/2022-02-20/fiveam-20220220-git.tgz
    MD5 9de18cdc08bc1104e46af99f05697e16 NAME fiveam FILENAME fiveam DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME net.didierverna.asdf-flv FILENAME net_dot_didierverna_dot_asdf-flv)
     (NAME trivial-backtrace FILENAME trivial-backtrace))
    DEPENDENCIES (alexandria net.didierverna.asdf-flv trivial-backtrace)
    VERSION 20220220-git SIBLINGS NIL PARASITES (fiveam/test)) */
