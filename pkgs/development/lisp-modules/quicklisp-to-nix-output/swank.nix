args @ { fetchurl, ... }:
rec {
  baseName = ''swank'';
  version = ''slime-v2.26'';

  description = ''System lacks description'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/slime/2020-09-25/slime-v2.26.tgz'';
    sha256 = ''0zba4vm73g9zamhqkqcb0prm51kf4clixm2rjz89mq180qa7rrqc'';
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION System lacks description SHA256
    0zba4vm73g9zamhqkqcb0prm51kf4clixm2rjz89mq180qa7rrqc URL
    http://beta.quicklisp.org/archive/slime/2020-09-25/slime-v2.26.tgz MD5
    8f18fbb04ca96733f683c863b44af484 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.26 SIBLINGS NIL PARASITES NIL) */
