{ fetchurl, ... }:
{
  baseName = ''plump-lexer'';
  version = ''plump-20170725-git'';

  description = ''A very simple toolkit to help with lexing used mainly in Plump.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz'';
    sha256 = ''118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72'';
  };

  packageName = "plump-lexer";

  asdFilesToKeep = ["plump-lexer.asd"];
  overrides = x: x;
}
/* (SYSTEM plump-lexer DESCRIPTION
    A very simple toolkit to help with lexing used mainly in Plump. SHA256
    118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72 URL
    http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz
    MD5 e5e92dd177711a14753ee86961710458 NAME plump-lexer FILENAME plump-lexer
    DEPS NIL DEPENDENCIES NIL VERSION plump-20170725-git SIBLINGS
    (plump-dom plump-parser plump) PARASITES NIL) */
