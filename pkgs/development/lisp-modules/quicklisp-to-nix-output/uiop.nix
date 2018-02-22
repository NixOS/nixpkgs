args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.3.1'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2017-12-27/uiop-3.3.1.tgz'';
    sha256 = ''0w9va40dr6l7fss9f7qlv7mp9f86sdjv5g2lz621a6wzi4911ghc'';
  };

  packageName = "uiop";

  asdFilesToKeep = ["uiop.asd"];
  overrides = x: x;
}
/* (SYSTEM uiop DESCRIPTION NIL SHA256
    0w9va40dr6l7fss9f7qlv7mp9f86sdjv5g2lz621a6wzi4911ghc URL
    http://beta.quicklisp.org/archive/uiop/2017-12-27/uiop-3.3.1.tgz MD5
    7a90377c4fc96676d5fa5197d9e9ec11 NAME uiop FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.3.1 SIBLINGS (asdf-driver) PARASITES NIL) */
