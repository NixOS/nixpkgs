/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fiveam";
  version = "20200925-git";

  parasites = [ "fiveam/test" ];

  description = "A simple regression testing framework";

  deps = [ args."alexandria" args."net_dot_didierverna_dot_asdf-flv" args."trivial-backtrace" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fiveam/2020-09-25/fiveam-20200925-git.tgz";
    sha256 = "0j9dzjs4prlx33f5idbcic4amx2mcgnjcyrpc3dd4b7lrw426l0d";
  };

  packageName = "fiveam";

  asdFilesToKeep = ["fiveam.asd"];
  overrides = x: x;
}
/* (SYSTEM fiveam DESCRIPTION A simple regression testing framework SHA256
    0j9dzjs4prlx33f5idbcic4amx2mcgnjcyrpc3dd4b7lrw426l0d URL
    http://beta.quicklisp.org/archive/fiveam/2020-09-25/fiveam-20200925-git.tgz
    MD5 858ecfdf7821630ad11e6859100d4650 NAME fiveam FILENAME fiveam DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME net.didierverna.asdf-flv FILENAME net_dot_didierverna_dot_asdf-flv)
     (NAME trivial-backtrace FILENAME trivial-backtrace))
    DEPENDENCIES (alexandria net.didierverna.asdf-flv trivial-backtrace)
    VERSION 20200925-git SIBLINGS NIL PARASITES (fiveam/test)) */
