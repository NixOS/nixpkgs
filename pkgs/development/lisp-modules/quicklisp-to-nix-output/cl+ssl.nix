args @ { fetchurl, ... }:
rec {
  baseName = ''cl+ssl'';
  version = ''cl+ssl-20170725-git'';

  parasites = [ "openssl-1.1.0" ];

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2017-07-25/cl+ssl-20170725-git.tgz'';
    sha256 = ''1p5886l5bwz4bj2xy8mpsjswg103b8saqdnw050a4wk9shpj1j69'';
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1p5886l5bwz4bj2xy8mpsjswg103b8saqdnw050a4wk9shpj1j69 URL
    http://beta.quicklisp.org/archive/cl+ssl/2017-07-25/cl+ssl-20170725-git.tgz
    MD5 3458c83f442395e0492c7e9b9720a1f2 NAME cl+ssl FILENAME cl+ssl DEPS
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
    VERSION cl+ssl-20170725-git SIBLINGS (cl+ssl.test) PARASITES
    (openssl-1.1.0)) */
