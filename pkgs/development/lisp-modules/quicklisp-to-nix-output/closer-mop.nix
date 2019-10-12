args @ { fetchurl, ... }:
{
  baseName = ''closer-mop'';
  version = ''20190710-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2019-07-10/closer-mop-20190710-git.tgz'';
    sha256 = ''0zh53f4jffzjl8ix9dks0shqcxnsj830a34iqgmz3prq8rwba0gx'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 0zh53f4jffzjl8ix9dks0shqcxnsj830a34iqgmz3prq8rwba0gx URL
    http://beta.quicklisp.org/archive/closer-mop/2019-07-10/closer-mop-20190710-git.tgz
    MD5 5ebb554f9f7ba7f0d9dc6584806c8a0e NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS NIL PARASITES NIL) */
