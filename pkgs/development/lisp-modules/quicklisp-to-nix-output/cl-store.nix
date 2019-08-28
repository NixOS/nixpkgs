args @ { fetchurl, ... }:
{
  baseName = ''cl-store'';
  version = ''20180328-git'';

  parasites = [ "cl-store-tests" ];

  description = ''Serialization package'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-store/2018-03-28/cl-store-20180328-git.tgz'';
    sha256 = ''1r5fmmpjcshfqv43zv282kjsxxp0imxd2fdpwwcr7y7m256w660n'';
  };

  packageName = "cl-store";

  asdFilesToKeep = ["cl-store.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-store DESCRIPTION Serialization package SHA256
    1r5fmmpjcshfqv43zv282kjsxxp0imxd2fdpwwcr7y7m256w660n URL
    http://beta.quicklisp.org/archive/cl-store/2018-03-28/cl-store-20180328-git.tgz
    MD5 2f8831cb60c0b0575c65e1dbebc07dee NAME cl-store FILENAME cl-store DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20180328-git SIBLINGS NIL
    PARASITES (cl-store-tests)) */
