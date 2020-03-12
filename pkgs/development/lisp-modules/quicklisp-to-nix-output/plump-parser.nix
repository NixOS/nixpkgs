args @ { fetchurl, ... }:
{
  baseName = ''plump-parser'';
  version = ''plump-20170725-git'';

  description = ''Plump's core parser component.'';

  deps = [ args."array-utils" args."plump-dom" args."plump-lexer" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz'';
    sha256 = ''118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72'';
  };

  packageName = "plump-parser";

  asdFilesToKeep = ["plump-parser.asd"];
  overrides = x: x;
}
/* (SYSTEM plump-parser DESCRIPTION Plump's core parser component. SHA256
    118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72 URL
    http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz
    MD5 e5e92dd177711a14753ee86961710458 NAME plump-parser FILENAME
    plump-parser DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME plump-dom FILENAME plump-dom)
     (NAME plump-lexer FILENAME plump-lexer)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils plump-dom plump-lexer trivial-indent) VERSION
    plump-20170725-git SIBLINGS (plump-dom plump-lexer plump) PARASITES NIL) */
