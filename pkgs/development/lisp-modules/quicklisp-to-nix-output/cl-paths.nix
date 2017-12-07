args @ { fetchurl, ... }:
rec {
  baseName = ''cl-paths'';
  version = ''cl-vectors-20170630-git'';

  description = ''cl-paths: vectorial paths manipulation'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz'';
    sha256 = ''0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740'';
  };

  packageName = "cl-paths";

  asdFilesToKeep = ["cl-paths.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-paths DESCRIPTION cl-paths: vectorial paths manipulation SHA256
    0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740 URL
    http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz
    MD5 cee3bb14adbba3142b782c646f7651ce NAME cl-paths FILENAME cl-paths DEPS
    NIL DEPENDENCIES NIL VERSION cl-vectors-20170630-git SIBLINGS
    (cl-aa-misc cl-aa cl-paths-ttf cl-vectors) PARASITES NIL) */
