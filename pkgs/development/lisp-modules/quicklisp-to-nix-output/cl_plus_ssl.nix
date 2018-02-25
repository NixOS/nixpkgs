args @ { fetchurl, ... }:
rec {
  baseName = ''cl_plus_ssl'';
  version = ''cl+ssl-20171227-git'';

  parasites = [ "openssl-1.1.0" ];

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2017-12-27/cl+ssl-20171227-git.tgz'';
    sha256 = ''1m6wcyccjyrz44mq0v1gvmpi44i9phknym5pimmicx3jvjyr37s4'';
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1m6wcyccjyrz44mq0v1gvmpi44i9phknym5pimmicx3jvjyr37s4 URL
    http://beta.quicklisp.org/archive/cl+ssl/2017-12-27/cl+ssl-20171227-git.tgz
    MD5 d00ce843db6038e6ff33d19668b5e038 NAME cl+ssl FILENAME cl_plus_ssl DEPS
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
    VERSION cl+ssl-20171227-git SIBLINGS (cl+ssl.test) PARASITES
    (openssl-1.1.0)) */
