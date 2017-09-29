args @ { fetchurl, ... }:
rec {
  baseName = ''cl-paths-ttf'';
  version = ''cl-vectors-20170630-git'';

  description = ''cl-paths-ttf: vectorial paths manipulation'';

  deps = [ args."cl-paths" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz'';
    sha256 = ''0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740'';
  };

  packageName = "cl-paths-ttf";

  asdFilesToKeep = ["cl-paths-ttf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-paths-ttf DESCRIPTION cl-paths-ttf: vectorial paths manipulation
    SHA256 0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740 URL
    http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz
    MD5 cee3bb14adbba3142b782c646f7651ce NAME cl-paths-ttf FILENAME
    cl-paths-ttf DEPS
    ((NAME cl-paths FILENAME cl-paths) (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (cl-paths zpb-ttf) VERSION cl-vectors-20170630-git SIBLINGS
    (cl-aa-misc cl-aa cl-paths cl-vectors) PARASITES NIL) */
