args @ { fetchurl, ... }:
rec {
  baseName = ''named-readtables'';
  version = ''20200925-git'';

  parasites = [ "named-readtables/test" ];

  description = ''Library that creates a namespace for named readtable
  akin to the namespace of packages.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/named-readtables/2020-09-25/named-readtables-20200925-git.tgz'';
    sha256 = ''0klbvv2syv8a8agacxdjrmmhibvhgfbxxwv6k4hx0ifk6n5iazxl'';
  };

  packageName = "named-readtables";

  asdFilesToKeep = ["named-readtables.asd"];
  overrides = x: x;
}
/* (SYSTEM named-readtables DESCRIPTION
    Library that creates a namespace for named readtable
  akin to the namespace of packages.
    SHA256 0klbvv2syv8a8agacxdjrmmhibvhgfbxxwv6k4hx0ifk6n5iazxl URL
    http://beta.quicklisp.org/archive/named-readtables/2020-09-25/named-readtables-20200925-git.tgz
    MD5 b17873ea600fb6847537c2c584761c29 NAME named-readtables FILENAME
    named-readtables DEPS NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS
    NIL PARASITES (named-readtables/test)) */
