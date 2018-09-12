args @ { fetchurl, ... }:
rec {
  baseName = ''cl_plus_ssl'';
  version = ''cl+ssl-20180831-git'';

  parasites = [ "openssl-1.1.0" ];

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2018-08-31/cl+ssl-20180831-git.tgz'';
    sha256 = ''1b35wz228kgcp9hc30mi38d004q2ixbv1b3krwycclnk4m65bl2r'';
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1b35wz228kgcp9hc30mi38d004q2ixbv1b3krwycclnk4m65bl2r URL
    http://beta.quicklisp.org/archive/cl+ssl/2018-08-31/cl+ssl-20180831-git.tgz
    MD5 56cd0b42cd9f7b8645db330ebc98600c NAME cl+ssl FILENAME cl_plus_ssl DEPS
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
    VERSION cl+ssl-20180831-git SIBLINGS (cl+ssl.test) PARASITES
    (openssl-1.1.0)) */
