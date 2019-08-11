args @ { fetchurl, ... }:
rec {
  baseName = ''cl-jpeg'';
  version = ''20170630-git'';

  description = ''A self-contained baseline JPEG codec implementation'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-jpeg/2017-06-30/cl-jpeg-20170630-git.tgz'';
    sha256 = ''1wwzn2valhh5ka7qkmab59pb1ijagcj296553fp8z03migl0sil0'';
  };

  packageName = "cl-jpeg";

  asdFilesToKeep = ["cl-jpeg.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-jpeg DESCRIPTION
    A self-contained baseline JPEG codec implementation SHA256
    1wwzn2valhh5ka7qkmab59pb1ijagcj296553fp8z03migl0sil0 URL
    http://beta.quicklisp.org/archive/cl-jpeg/2017-06-30/cl-jpeg-20170630-git.tgz
    MD5 b6eb4ca5d893f428b5bbe46cd49f76ad NAME cl-jpeg FILENAME cl-jpeg DEPS NIL
    DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL PARASITES NIL) */
