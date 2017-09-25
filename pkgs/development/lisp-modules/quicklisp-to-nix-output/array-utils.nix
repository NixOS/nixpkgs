args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20170630-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2017-06-30/array-utils-20170630-git.tgz'';
    sha256 = ''1nj42w2q11qdg65cviaj514pcql1gi729mcsj5g2vy17pr298zgb'';
  };

  packageName = "array-utils";

  asdFilesToKeep = ["array-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays.
    SHA256 1nj42w2q11qdg65cviaj514pcql1gi729mcsj5g2vy17pr298zgb URL
    http://beta.quicklisp.org/archive/array-utils/2017-06-30/array-utils-20170630-git.tgz
    MD5 550b37bc0eccfafa889de00b59c422dc NAME array-utils FILENAME array-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS (array-utils-test)
    PARASITES NIL) */
