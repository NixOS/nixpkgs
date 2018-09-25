args @ { fetchurl, ... }:
rec {
  baseName = ''salza2'';
  version = ''2.0.9'';

  description = ''Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz'';
    sha256 = ''1m0hksgvq3njd9xa2nxlm161vgzw77djxmisq08v9pz2bz16v8va'';
  };

  packageName = "salza2";

  asdFilesToKeep = ["salza2.asd"];
  overrides = x: x;
}
/* (SYSTEM salza2 DESCRIPTION
    Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats
    SHA256 1m0hksgvq3njd9xa2nxlm161vgzw77djxmisq08v9pz2bz16v8va URL
    http://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz MD5
    e62383de435081c0f1f888ec363bb32c NAME salza2 FILENAME salza2 DEPS NIL
    DEPENDENCIES NIL VERSION 2.0.9 SIBLINGS NIL PARASITES NIL) */
