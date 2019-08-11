args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''20180430-git'';

  parasites = [ "cl-fad-test" ];

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2018-04-30/cl-fad-20180430-git.tgz'';
    sha256 = ''175v6y32q6qpc8axacf8nw44pmsw7a6r476w0f01cp1gwvpis1cs'';
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    175v6y32q6qpc8axacf8nw44pmsw7a6r476w0f01cp1gwvpis1cs URL
    http://beta.quicklisp.org/archive/cl-fad/2018-04-30/cl-fad-20180430-git.tgz
    MD5 005c1b7b376fc60dea72574d2acdc704 NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION
    20180430-git SIBLINGS NIL PARASITES (cl-fad-test)) */
