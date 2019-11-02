args @ { fetchurl, ... }:
rec {
  baseName = ''cl_plus_ssl'';
  version = ''cl+ssl-20190710-git'';

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2019-07-10/cl+ssl-20190710-git.tgz'';
    sha256 = ''0lxyd8nryhk9f8gg0fksqf3y5lgbb7f61snsc3qzi5gplkdy0mzv'';
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    0lxyd8nryhk9f8gg0fksqf3y5lgbb7f61snsc3qzi5gplkdy0mzv URL
    http://beta.quicklisp.org/archive/cl+ssl/2019-07-10/cl+ssl-20190710-git.tgz
    MD5 fae6e01902964d010ad2565a61a6af2a NAME cl+ssl FILENAME cl_plus_ssl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi flexi-streams trivial-features
     trivial-garbage trivial-gray-streams uiop)
    VERSION cl+ssl-20190710-git SIBLINGS (cl+ssl.test) PARASITES NIL) */
