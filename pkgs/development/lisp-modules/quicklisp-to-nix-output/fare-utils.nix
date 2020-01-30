args @ { fetchurl, ... }:
rec {
  baseName = ''fare-utils'';
  version = ''20170124-git'';

  description = ''Basic functions and macros, interfaces, pure and stateful datastructures'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fare-utils/2017-01-24/fare-utils-20170124-git.tgz'';
    sha256 = ''0jhb018ccn3spkgjywgd0524m5qacn8x15fdiban4zz3amj9dapq'';
  };

  packageName = "fare-utils";

  asdFilesToKeep = ["fare-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-utils DESCRIPTION
    Basic functions and macros, interfaces, pure and stateful datastructures
    SHA256 0jhb018ccn3spkgjywgd0524m5qacn8x15fdiban4zz3amj9dapq URL
    http://beta.quicklisp.org/archive/fare-utils/2017-01-24/fare-utils-20170124-git.tgz
    MD5 6752362d0c7c03df6576ab2dbe807ee2 NAME fare-utils FILENAME fare-utils
    DEPS NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS (fare-utils-test)
    PARASITES NIL) */
