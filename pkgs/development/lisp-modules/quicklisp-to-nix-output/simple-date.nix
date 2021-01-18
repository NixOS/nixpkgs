args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20201016-git'';

  parasites = [ "simple-date/tests" ];

  description = ''Simple date library that can be used with postmodern'';

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2020-10-16/postmodern-20201016-git.tgz'';
    sha256 = ''1svaiksbqcaq8sh7q6sj9kzazdfl360zqr2nzhwbgy4xnaj4vf3n'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION
    Simple date library that can be used with postmodern SHA256
    1svaiksbqcaq8sh7q6sj9kzazdfl360zqr2nzhwbgy4xnaj4vf3n URL
    http://beta.quicklisp.org/archive/postmodern/2020-10-16/postmodern-20201016-git.tgz
    MD5 f61e827d7e7ba023f6fbc7c2667de4c8 NAME simple-date FILENAME simple-date
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    postmodern-20201016-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/tests)) */
