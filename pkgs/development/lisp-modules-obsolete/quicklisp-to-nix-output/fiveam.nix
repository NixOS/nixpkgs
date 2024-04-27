/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fiveam";
  version = "20211209-git";

  parasites = [ "fiveam/test" ];

  description = "A simple regression testing framework";

  deps = [ args."alexandria" args."net_dot_didierverna_dot_asdf-flv" args."trivial-backtrace" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fiveam/2021-12-09/fiveam-20211209-git.tgz";
    sha256 = "0kyyr2dlgpzkn2cw9i4fwyip1d1la4cbv8l4b8jz31f5c1p76ab7";
  };

  packageName = "fiveam";

  asdFilesToKeep = ["fiveam.asd"];
  overrides = x: x;
}
/* (SYSTEM fiveam DESCRIPTION A simple regression testing framework SHA256
    0kyyr2dlgpzkn2cw9i4fwyip1d1la4cbv8l4b8jz31f5c1p76ab7 URL
    http://beta.quicklisp.org/archive/fiveam/2021-12-09/fiveam-20211209-git.tgz
    MD5 10d6a5a19f47ed94cbd9edf1d4c20933 NAME fiveam FILENAME fiveam DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME net.didierverna.asdf-flv FILENAME net_dot_didierverna_dot_asdf-flv)
     (NAME trivial-backtrace FILENAME trivial-backtrace))
    DEPENDENCIES (alexandria net.didierverna.asdf-flv trivial-backtrace)
    VERSION 20211209-git SIBLINGS NIL PARASITES (fiveam/test)) */
