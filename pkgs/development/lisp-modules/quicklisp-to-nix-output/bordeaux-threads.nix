args @ { fetchurl, ... }:
rec {
  baseName = ''bordeaux-threads'';
  version = ''v0.8.5'';

  parasites = [ "bordeaux-threads/test" ];

  description = ''Bordeaux Threads makes writing portable multi-threaded apps simple.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz'';
    sha256 = ''09q1xd3fca6ln6mh45cx24xzkrcnvhgl5nn9g2jv0rwj1m2xvbpd'';
  };

  packageName = "bordeaux-threads";

  asdFilesToKeep = ["bordeaux-threads.asd"];
  overrides = x: x;
}
/* (SYSTEM bordeaux-threads DESCRIPTION
    Bordeaux Threads makes writing portable multi-threaded apps simple. SHA256
    09q1xd3fca6ln6mh45cx24xzkrcnvhgl5nn9g2jv0rwj1m2xvbpd URL
    http://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz
    MD5 67e363a363e164b6f61a047957b8554e NAME bordeaux-threads FILENAME
    bordeaux-threads DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION v0.8.5 SIBLINGS NIL PARASITES
    (bordeaux-threads/test)) */
