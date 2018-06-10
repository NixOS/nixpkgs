args @ { fetchurl, ... }:
rec {
  baseName = ''cl_plus_ssl'';
  version = ''cl+ssl-20180328-git'';

  parasites = [ "openssl-1.1.0" ];

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2018-03-28/cl+ssl-20180328-git.tgz'';
    sha256 = ''095rn0dl0izjambjry4n4j72l9abijhlvs47h44a2mcgjc9alj62'';
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    095rn0dl0izjambjry4n4j72l9abijhlvs47h44a2mcgjc9alj62 URL
    http://beta.quicklisp.org/archive/cl+ssl/2018-03-28/cl+ssl-20180328-git.tgz
    MD5 ec6f921505ba7bb8e35878b3ae9eea29 NAME cl+ssl FILENAME cl_plus_ssl DEPS
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
    VERSION cl+ssl-20180328-git SIBLINGS (cl+ssl.test) PARASITES
    (openssl-1.1.0)) */
