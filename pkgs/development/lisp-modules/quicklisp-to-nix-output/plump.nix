args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20170725-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."plump-dom" args."plump-lexer" args."plump-parser" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz'';
    sha256 = ''118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72 URL
    http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz
    MD5 e5e92dd177711a14753ee86961710458 NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME plump-dom FILENAME plump-dom)
     (NAME plump-lexer FILENAME plump-lexer)
     (NAME plump-parser FILENAME plump-parser)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils plump-dom plump-lexer plump-parser trivial-indent) VERSION
    20170725-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
