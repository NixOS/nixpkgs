args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fad'';
  version = ''20190813-git'';

  parasites = [ "cl-fad-test" ];

  description = ''Portable pathname library'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fad/2019-08-13/cl-fad-20190813-git.tgz'';
    sha256 = ''0kixjb6cqpcmlac5mh4qjlnhjbww32f3pn89g0cnwvz952y8nlng'';
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    0kixjb6cqpcmlac5mh4qjlnhjbww32f3pn89g0cnwvz952y8nlng URL
    http://beta.quicklisp.org/archive/cl-fad/2019-08-13/cl-fad-20190813-git.tgz
    MD5 7d0405b44fefccb8a807527249ee2700 NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION
    20190813-git SIBLINGS NIL PARASITES (cl-fad-test)) */
