args @ { fetchurl, ... }:
{
  baseName = ''plump-dom'';
  version = ''plump-20170725-git'';

  description = ''A DOM for use with the Plump parser.'';

  deps = [ args."array-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz'';
    sha256 = ''118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72'';
  };

  packageName = "plump-dom";

  asdFilesToKeep = ["plump-dom.asd"];
  overrides = x: x;
}
/* (SYSTEM plump-dom DESCRIPTION A DOM for use with the Plump parser. SHA256
    118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72 URL
    http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz
    MD5 e5e92dd177711a14753ee86961710458 NAME plump-dom FILENAME plump-dom DEPS
    ((NAME array-utils FILENAME array-utils)) DEPENDENCIES (array-utils)
    VERSION plump-20170725-git SIBLINGS (plump-lexer plump-parser plump)
    PARASITES NIL) */
