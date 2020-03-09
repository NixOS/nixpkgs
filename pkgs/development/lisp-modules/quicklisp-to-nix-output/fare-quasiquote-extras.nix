args @ { fetchurl, ... }:
rec {
  baseName = ''fare-quasiquote-extras'';
  version = ''fare-quasiquote-20190521-git'';

  description = ''fare-quasiquote plus extras'';

  deps = [ args."alexandria" args."closer-mop" args."fare-quasiquote" args."fare-quasiquote-optima" args."fare-quasiquote-readtable" args."fare-utils" args."named-readtables" args."optima" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz'';
    sha256 = ''1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj'';
  };

  packageName = "fare-quasiquote-extras";

  asdFilesToKeep = ["fare-quasiquote-extras.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote-extras DESCRIPTION fare-quasiquote plus extras
    SHA256 1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz
    MD5 e08c24d35a485a74642bd0c7c06662d6 NAME fare-quasiquote-extras FILENAME
    fare-quasiquote-extras DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-quasiquote-optima FILENAME fare-quasiquote-optima)
     (NAME fare-quasiquote-readtable FILENAME fare-quasiquote-readtable)
     (NAME fare-utils FILENAME fare-utils)
     (NAME named-readtables FILENAME named-readtables)
     (NAME optima FILENAME optima))
    DEPENDENCIES
    (alexandria closer-mop fare-quasiquote fare-quasiquote-optima
     fare-quasiquote-readtable fare-utils named-readtables optima)
    VERSION fare-quasiquote-20190521-git SIBLINGS
    (fare-quasiquote-optima fare-quasiquote-readtable fare-quasiquote-test
     fare-quasiquote)
    PARASITES NIL) */
