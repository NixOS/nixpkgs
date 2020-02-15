args @ { fetchurl, ... }:
rec {
  baseName = ''fare-quasiquote-optima'';
  version = ''fare-quasiquote-20190521-git'';

  description = ''fare-quasiquote extension for optima'';

  deps = [ args."alexandria" args."closer-mop" args."fare-quasiquote" args."fare-utils" args."optima" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz'';
    sha256 = ''1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj'';
  };

  packageName = "fare-quasiquote-optima";

  asdFilesToKeep = ["fare-quasiquote-optima.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote-optima DESCRIPTION
    fare-quasiquote extension for optima SHA256
    1skrj68dnmihckip1vyc31xysbdsw9ihb7imks73cickkvv6yjfj URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2019-05-21/fare-quasiquote-20190521-git.tgz
    MD5 e08c24d35a485a74642bd0c7c06662d6 NAME fare-quasiquote-optima FILENAME
    fare-quasiquote-optima DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-utils FILENAME fare-utils) (NAME optima FILENAME optima))
    DEPENDENCIES (alexandria closer-mop fare-quasiquote fare-utils optima)
    VERSION fare-quasiquote-20190521-git SIBLINGS
    (fare-quasiquote-extras fare-quasiquote-readtable fare-quasiquote-test
     fare-quasiquote)
    PARASITES NIL) */
