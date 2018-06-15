args @ { fetchurl, ... }:
rec {
  baseName = ''named-readtables'';
  version = ''20180131-git'';

  parasites = [ "named-readtables/test" ];

  description = ''Library that creates a namespace for named readtable
  akin to the namespace of packages.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/named-readtables/2018-01-31/named-readtables-20180131-git.tgz'';
    sha256 = ''1fhygm2q75m6my6appxmx097l7zlr3qxbgzbpa2mf9pr1qzwrgg5'';
  };

  packageName = "named-readtables";

  asdFilesToKeep = ["named-readtables.asd"];
  overrides = x: x;
}
/* (SYSTEM named-readtables DESCRIPTION
    Library that creates a namespace for named readtable
  akin to the namespace of packages.
    SHA256 1fhygm2q75m6my6appxmx097l7zlr3qxbgzbpa2mf9pr1qzwrgg5 URL
    http://beta.quicklisp.org/archive/named-readtables/2018-01-31/named-readtables-20180131-git.tgz
    MD5 46db18ba947dc0aba14c76471604448d NAME named-readtables FILENAME
    named-readtables DEPS NIL DEPENDENCIES NIL VERSION 20180131-git SIBLINGS
    NIL PARASITES (named-readtables/test)) */
