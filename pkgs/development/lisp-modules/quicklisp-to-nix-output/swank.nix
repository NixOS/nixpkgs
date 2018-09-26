args @ { fetchurl, ... }:
rec {
  baseName = ''swank'';
  version = ''slime-v2.22'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/slime/2018-08-31/slime-v2.22.tgz'';
    sha256 = ''0ql0bjijypghi884085idq542yms2gk4rq1035j3vznkqrlnaqbk'';
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION NIL SHA256
    0ql0bjijypghi884085idq542yms2gk4rq1035j3vznkqrlnaqbk URL
    http://beta.quicklisp.org/archive/slime/2018-08-31/slime-v2.22.tgz MD5
    edf090905d4f3a54ef62f8c13972bba5 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.22 SIBLINGS NIL PARASITES NIL) */
