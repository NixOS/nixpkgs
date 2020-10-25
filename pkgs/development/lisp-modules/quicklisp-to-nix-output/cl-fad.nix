args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''20200610-git'';

  parasites = [ "cl-fad-test" ];

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2020-06-10/cl-fad-20200610-git.tgz'';
    sha256 = ''08d0q2jpjz4djz20w8m86rfkili8g0vdbkkmvn8c88qmvcr79k5x'';
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    08d0q2jpjz4djz20w8m86rfkili8g0vdbkkmvn8c88qmvcr79k5x URL
    http://beta.quicklisp.org/archive/cl-fad/2020-06-10/cl-fad-20200610-git.tgz
    MD5 3229249f64a5ca0f32ce9448e4f554ea NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION
    20200610-git SIBLINGS NIL PARASITES (cl-fad-test)) */
