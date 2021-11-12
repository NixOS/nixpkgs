/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "log4cl";
  version = "20211020-git";

  parasites = [ "log4cl/syslog" "log4cl/test" ];

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."stefil" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/log4cl/2021-10-20/log4cl-20211020-git.tgz";
    sha256 = "1nqryqd5z4grg75hffqs2x6nzdf972cp4f41l1dr8wdf3fp0ifz8";
  };

  packageName = "log4cl";

  asdFilesToKeep = ["log4cl.asd"];
  overrides = x: x;
}
/* (SYSTEM log4cl DESCRIPTION System lacks description SHA256
    1nqryqd5z4grg75hffqs2x6nzdf972cp4f41l1dr8wdf3fp0ifz8 URL
    http://beta.quicklisp.org/archive/log4cl/2021-10-20/log4cl-20211020-git.tgz
    MD5 d4eb0d4c8a9bc2f2037d7a64d44292d4 NAME log4cl FILENAME log4cl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads stefil) VERSION 20211020-git
    SIBLINGS (log4cl-examples log4cl.log4slime log4cl.log4sly) PARASITES
    (log4cl/syslog log4cl/test)) */
