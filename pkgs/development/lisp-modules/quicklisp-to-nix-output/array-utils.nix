args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20190710-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2019-07-10/array-utils-20190710-git.tgz'';
    sha256 = ''1fzsg3lqa79yrkad6fx924vai7i6m92i2rq8lyq37wrbwkhm7grh'';
  };

  packageName = "array-utils";

  asdFilesToKeep = ["array-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays.
    SHA256 1fzsg3lqa79yrkad6fx924vai7i6m92i2rq8lyq37wrbwkhm7grh URL
    http://beta.quicklisp.org/archive/array-utils/2019-07-10/array-utils-20190710-git.tgz
    MD5 58c39c2ba3d2c8cd8a695fb867b72c33 NAME array-utils FILENAME array-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS (array-utils-test)
    PARASITES NIL) */
