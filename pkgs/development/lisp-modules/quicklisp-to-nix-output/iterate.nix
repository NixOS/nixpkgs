args @ { fetchurl, ... }:
rec {
  baseName = ''iterate'';
  version = ''20180131-darcs'';

  parasites = [ "iterate/tests" ];

  description = ''Jonathan Amsterdam's iterator/gatherer/accumulator facility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iterate/2018-01-31/iterate-20180131-darcs.tgz'';
    sha256 = ''05jlwd59w13k4n9x7a0mszdv7i78cbmx93w2p1yzsi30593rh9hj'';
  };

  packageName = "iterate";

  asdFilesToKeep = ["iterate.asd"];
  overrides = x: x;
}
/* (SYSTEM iterate DESCRIPTION
    Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256
    05jlwd59w13k4n9x7a0mszdv7i78cbmx93w2p1yzsi30593rh9hj URL
    http://beta.quicklisp.org/archive/iterate/2018-01-31/iterate-20180131-darcs.tgz
    MD5 40a1776b445e42463c2c6f754468fb83 NAME iterate FILENAME iterate DEPS NIL
    DEPENDENCIES NIL VERSION 20180131-darcs SIBLINGS NIL PARASITES
    (iterate/tests)) */
