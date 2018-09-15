args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.3.2'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2018-07-11/uiop-3.3.2.tgz'';
    sha256 = ''1q13a7dzc9vpd0w7c4xw03ijmlnyhjw2p76h0v8m7dyb23s7p9y5'';
  };

  packageName = "uiop";

  asdFilesToKeep = ["uiop.asd"];
  overrides = x: x;
}
/* (SYSTEM uiop DESCRIPTION NIL SHA256
    1q13a7dzc9vpd0w7c4xw03ijmlnyhjw2p76h0v8m7dyb23s7p9y5 URL
    http://beta.quicklisp.org/archive/uiop/2018-07-11/uiop-3.3.2.tgz MD5
    8d7b7b4065873107147678c6ef72e5ee NAME uiop FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.3.2 SIBLINGS (asdf-driver) PARASITES NIL) */
