args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20180831-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2018-08-31/array-utils-20180831-git.tgz'';
    sha256 = ''1m3ciz73psy3gln5f2q1c6igfmhxjjq97bqbjsvmyj2l9f6m6bl7'';
  };

  packageName = "array-utils";

  asdFilesToKeep = ["array-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays.
    SHA256 1m3ciz73psy3gln5f2q1c6igfmhxjjq97bqbjsvmyj2l9f6m6bl7 URL
    http://beta.quicklisp.org/archive/array-utils/2018-08-31/array-utils-20180831-git.tgz
    MD5 fa07e8fac5263d4fed7acb3d53e5855a NAME array-utils FILENAME array-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20180831-git SIBLINGS (array-utils-test)
    PARASITES NIL) */
