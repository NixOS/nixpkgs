/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "closer-mop";
  version = "20211020-git";

  description = "Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/closer-mop/2021-10-20/closer-mop-20211020-git.tgz";
    sha256 = "1m5ri5br262li2w4qljbplrgk6pm1w5vil5qa71bc1h7fbl0qh07";
  };

  packageName = "closer-mop";

  asdFilesToKeep = ["closer-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 1m5ri5br262li2w4qljbplrgk6pm1w5vil5qa71bc1h7fbl0qh07 URL
    http://beta.quicklisp.org/archive/closer-mop/2021-10-20/closer-mop-20211020-git.tgz
    MD5 09606b3803a2b3d727fb94cc59313bd8 NAME closer-mop FILENAME closer-mop
    DEPS NIL DEPENDENCIES NIL VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
