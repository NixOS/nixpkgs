args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20180131-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2018-01-31/array-utils-20180131-git.tgz'';
    sha256 = ''01vjb146lb1dp77xcpinq4r1jv2fvl3gzj50x9i04b5mhfaqpkd0'';
  };

  packageName = "array-utils";

  asdFilesToKeep = ["array-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays.
    SHA256 01vjb146lb1dp77xcpinq4r1jv2fvl3gzj50x9i04b5mhfaqpkd0 URL
    http://beta.quicklisp.org/archive/array-utils/2018-01-31/array-utils-20180131-git.tgz
    MD5 339670a03dd7d865cd045a6556d705c6 NAME array-utils FILENAME array-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20180131-git SIBLINGS (array-utils-test)
    PARASITES NIL) */
