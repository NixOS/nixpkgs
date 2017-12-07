args @ { fetchurl, ... }:
rec {
  baseName = ''fiveam'';
  version = ''v1.3'';

  parasites = [ "fiveam/test" ];

  description = ''A simple regression testing framework'';

  deps = [ args."alexandria" args."net_dot_didierverna_dot_asdf-flv" args."trivial-backtrace" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiveam/2016-08-25/fiveam-v1.3.tgz'';
    sha256 = ''0cdjl3lg1xib5mc3rnw80n58zxmf3hz1xa567lq4jvh8kzxl30q2'';
  };

  packageName = "fiveam";

  asdFilesToKeep = ["fiveam.asd"];
  overrides = x: x;
}
/* (SYSTEM fiveam DESCRIPTION A simple regression testing framework SHA256
    0cdjl3lg1xib5mc3rnw80n58zxmf3hz1xa567lq4jvh8kzxl30q2 URL
    http://beta.quicklisp.org/archive/fiveam/2016-08-25/fiveam-v1.3.tgz MD5
    bd03a588915f834031eeae9139c51aa4 NAME fiveam FILENAME fiveam DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME net.didierverna.asdf-flv FILENAME net_dot_didierverna_dot_asdf-flv)
     (NAME trivial-backtrace FILENAME trivial-backtrace))
    DEPENDENCIES (alexandria net.didierverna.asdf-flv trivial-backtrace)
    VERSION v1.3 SIBLINGS NIL PARASITES (fiveam/test)) */
