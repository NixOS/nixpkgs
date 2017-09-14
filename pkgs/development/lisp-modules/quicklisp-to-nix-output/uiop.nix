args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.2.1'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2017-06-30/uiop-3.2.1.tgz'';
    sha256 = ''1zl661dkbg5clyl5fjj9466krk59xfdmmfzci5mj7n137m0zmf5v'';
  };

  packageName = "uiop";

  asdFilesToKeep = ["uiop.asd"];
  overrides = x: x;
}
/* (SYSTEM uiop DESCRIPTION NIL SHA256
    1zl661dkbg5clyl5fjj9466krk59xfdmmfzci5mj7n137m0zmf5v URL
    http://beta.quicklisp.org/archive/uiop/2017-06-30/uiop-3.2.1.tgz MD5
    3e9ef02ecf9005240b66552d85719700 NAME uiop FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.2.1 SIBLINGS (asdf-driver) PARASITES NIL) */
