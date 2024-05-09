/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "array-utils";
  version = "20201220-git";

  description = "A few utilities for working with arrays.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/array-utils/2020-12-20/array-utils-20201220-git.tgz";
    sha256 = "11y6k8gzzcj00jyccg2k9nh6rvivcvh23z4yzjfly7adygd3n717";
  };

  packageName = "array-utils";

  asdFilesToKeep = ["array-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays.
    SHA256 11y6k8gzzcj00jyccg2k9nh6rvivcvh23z4yzjfly7adygd3n717 URL
    http://beta.quicklisp.org/archive/array-utils/2020-12-20/array-utils-20201220-git.tgz
    MD5 d6ed906f28c46b2ab0335ec1fc05f8af NAME array-utils FILENAME array-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20201220-git SIBLINGS (array-utils-test)
    PARASITES NIL) */
