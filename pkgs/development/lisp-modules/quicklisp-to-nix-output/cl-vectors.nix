args @ { fetchurl, ... }:
rec {
  baseName = ''cl-vectors'';
  version = ''20170630-git'';

  description = ''cl-paths: vectorial paths manipulation'';

  deps = [ args."cl-aa" args."cl-paths" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz'';
    sha256 = ''0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740'';
  };

  packageName = "cl-vectors";

  asdFilesToKeep = ["cl-vectors.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-vectors DESCRIPTION cl-paths: vectorial paths manipulation SHA256
    0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740 URL
    http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz
    MD5 cee3bb14adbba3142b782c646f7651ce NAME cl-vectors FILENAME cl-vectors
    DEPS ((NAME cl-aa FILENAME cl-aa) (NAME cl-paths FILENAME cl-paths))
    DEPENDENCIES (cl-aa cl-paths) VERSION 20170630-git SIBLINGS
    (cl-aa-misc cl-aa cl-paths-ttf cl-paths) PARASITES NIL) */
