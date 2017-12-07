args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20170725-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2017-07-25/closer-mop-20170725-git.tgz'';
    sha256 = ''0qc4zh4zicv3zm4bw8c3s2r2bjbx2bp31j69lwiz1mdl9xg0nhsc'';
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 0qc4zh4zicv3zm4bw8c3s2r2bjbx2bp31j69lwiz1mdl9xg0nhsc URL
    http://beta.quicklisp.org/archive/closer-mop/2017-07-25/closer-mop-20170725-git.tgz
    MD5 308f9e8e4ea4573c7b6820055b6f171d NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20170725-git SIBLINGS NIL PARASITES NIL) */
