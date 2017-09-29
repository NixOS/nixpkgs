args @ { fetchurl, ... }:
rec {
  baseName = ''ieee-floats'';
  version = ''20160318-git'';

  parasites = [ "ieee-floats-tests" ];

  description = '''';

  deps = [ args."eos" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ieee-floats/2016-03-18/ieee-floats-20160318-git.tgz'';
    sha256 = ''0vw4q6q5yygfxfwx5bki4kl9lqszmhnplcl55qh8raxmb03alyx4'';
  };

  packageName = "ieee-floats";

  asdFilesToKeep = ["ieee-floats.asd"];
  overrides = x: x;
}
/* (SYSTEM ieee-floats DESCRIPTION NIL SHA256
    0vw4q6q5yygfxfwx5bki4kl9lqszmhnplcl55qh8raxmb03alyx4 URL
    http://beta.quicklisp.org/archive/ieee-floats/2016-03-18/ieee-floats-20160318-git.tgz
    MD5 84d679a4dffddc3b0cff944adde623c5 NAME ieee-floats FILENAME ieee-floats
    DEPS ((NAME eos FILENAME eos)) DEPENDENCIES (eos) VERSION 20160318-git
    SIBLINGS NIL PARASITES (ieee-floats-tests)) */
