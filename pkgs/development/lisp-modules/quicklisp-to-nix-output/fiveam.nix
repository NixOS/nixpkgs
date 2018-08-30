args @ { fetchurl, ... }:
rec {
  baseName = ''fiveam'';
  version = ''v1.4.1'';

  parasites = [ "fiveam/test" ];

  description = ''A simple regression testing framework'';

  deps = [ args."alexandria" args."net_dot_didierverna_dot_asdf-flv" args."trivial-backtrace" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiveam/2018-02-28/fiveam-v1.4.1.tgz'';
    sha256 = ''06y82y58x0haj20pkbqvm1rv19adafyvf01q56v73yhzs94nb7f3'';
  };

  packageName = "fiveam";

  asdFilesToKeep = ["fiveam.asd"];
  overrides = x: x;
}
/* (SYSTEM fiveam DESCRIPTION A simple regression testing framework SHA256
    06y82y58x0haj20pkbqvm1rv19adafyvf01q56v73yhzs94nb7f3 URL
    http://beta.quicklisp.org/archive/fiveam/2018-02-28/fiveam-v1.4.1.tgz MD5
    7f182f8a4c12b98671e1707ae0f140b7 NAME fiveam FILENAME fiveam DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME net.didierverna.asdf-flv FILENAME net_dot_didierverna_dot_asdf-flv)
     (NAME trivial-backtrace FILENAME trivial-backtrace))
    DEPENDENCIES (alexandria net.didierverna.asdf-flv trivial-backtrace)
    VERSION v1.4.1 SIBLINGS NIL PARASITES (fiveam/test)) */
