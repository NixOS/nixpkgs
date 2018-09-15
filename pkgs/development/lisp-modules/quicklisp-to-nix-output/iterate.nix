args @ { fetchurl, ... }:
rec {
  baseName = ''iterate'';
  version = ''20180228-git'';

  parasites = [ "iterate/tests" ];

  description = ''Jonathan Amsterdam's iterator/gatherer/accumulator facility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iterate/2018-02-28/iterate-20180228-git.tgz'';
    sha256 = ''0bz5dspx778v2fdfbi5x8v8r56mmda8svhp3immjkrpzc21rc7ib'';
  };

  packageName = "iterate";

  asdFilesToKeep = ["iterate.asd"];
  overrides = x: x;
}
/* (SYSTEM iterate DESCRIPTION
    Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256
    0bz5dspx778v2fdfbi5x8v8r56mmda8svhp3immjkrpzc21rc7ib URL
    http://beta.quicklisp.org/archive/iterate/2018-02-28/iterate-20180228-git.tgz
    MD5 ee3b198b0f9674c11e5283e56f57ed78 NAME iterate FILENAME iterate DEPS NIL
    DEPENDENCIES NIL VERSION 20180228-git SIBLINGS NIL PARASITES
    (iterate/tests)) */
