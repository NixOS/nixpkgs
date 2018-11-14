args @ { fetchurl, ... }:
rec {
  baseName = ''yacc'';
  version = ''cl-20101006-darcs'';

  description = ''A LALR(1) parser generator for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-yacc/2010-10-06/cl-yacc-20101006-darcs.tgz'';
    sha256 = ''0cymvl0arp4yahqcnhxggs1z2g42bf6z4ix75ba7wbsi52zirjp7'';
  };

  packageName = "yacc";

  asdFilesToKeep = ["yacc.asd"];
  overrides = x: x;
}
/* (SYSTEM yacc DESCRIPTION A LALR(1) parser generator for Common Lisp SHA256
    0cymvl0arp4yahqcnhxggs1z2g42bf6z4ix75ba7wbsi52zirjp7 URL
    http://beta.quicklisp.org/archive/cl-yacc/2010-10-06/cl-yacc-20101006-darcs.tgz
    MD5 748b9d59de8be3ccfdf0f001e15972ba NAME yacc FILENAME yacc DEPS NIL
    DEPENDENCIES NIL VERSION cl-20101006-darcs SIBLINGS NIL PARASITES NIL) */
