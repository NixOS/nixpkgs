args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20181018-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2018-10-18/array-utils-20181018-git.tgz'';
    sha256 = ''1w13zwdhms4xbsnp9p6j71a4ppzglhxm81savyq0spf3zlm2l5yn'';
  };

  packageName = "array-utils";

  asdFilesToKeep = ["array-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays.
    SHA256 1w13zwdhms4xbsnp9p6j71a4ppzglhxm81savyq0spf3zlm2l5yn URL
    http://beta.quicklisp.org/archive/array-utils/2018-10-18/array-utils-20181018-git.tgz
    MD5 e32cc0474cf299ad1f5666e2864aa3d8 NAME array-utils FILENAME array-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20181018-git SIBLINGS (array-utils-test)
    PARASITES NIL) */
