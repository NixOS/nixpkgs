args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''20171227-git'';

  parasites = [ "cl-fad-test" ];

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2017-12-27/cl-fad-20171227-git.tgz'';
    sha256 = ''0dl2c1klv55vk99j1b31f2s1rd1m9c94l1n0aly8spwxz3yd3za8'';
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    0dl2c1klv55vk99j1b31f2s1rd1m9c94l1n0aly8spwxz3yd3za8 URL
    http://beta.quicklisp.org/archive/cl-fad/2017-12-27/cl-fad-20171227-git.tgz
    MD5 f6b34f61ebba1c68e8fe122bb7de3f77 NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION
    20171227-git SIBLINGS NIL PARASITES (cl-fad-test)) */
