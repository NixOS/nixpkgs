args @ { fetchurl, ... }:
rec {
  baseName = ''bordeaux-threads'';
  version = ''v0.8.7'';

  parasites = [ "bordeaux-threads/test" ];

  description = ''Bordeaux Threads makes writing portable multi-threaded apps simple.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/bordeaux-threads/2019-11-30/bordeaux-threads-v0.8.7.tgz'';
    sha256 = ''1an8fgam16nyhfninm0gl8k666f93k9j7kwmg43g8qcimyaj3l6w'';
  };

  packageName = "bordeaux-threads";

  asdFilesToKeep = ["bordeaux-threads.asd"];
  overrides = x: x;
}
/* (SYSTEM bordeaux-threads DESCRIPTION
    Bordeaux Threads makes writing portable multi-threaded apps simple. SHA256
    1an8fgam16nyhfninm0gl8k666f93k9j7kwmg43g8qcimyaj3l6w URL
    http://beta.quicklisp.org/archive/bordeaux-threads/2019-11-30/bordeaux-threads-v0.8.7.tgz
    MD5 071b427dd047999ffe038a2ef848ac13 NAME bordeaux-threads FILENAME
    bordeaux-threads DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION v0.8.7 SIBLINGS NIL PARASITES
    (bordeaux-threads/test)) */
