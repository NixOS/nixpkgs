args @ { fetchurl, ... }:
rec {
  baseName = ''log4cl'';
  version = ''20191007-git'';

  parasites = [ "log4cl/syslog" "log4cl/test" ];

  description = ''System lacks description'';

  deps = [ args."alexandria" args."bordeaux-threads" args."stefil" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/log4cl/2019-10-07/log4cl-20191007-git.tgz'';
    sha256 = ''0i4i4ahw13fzka8ixasv292y59ljyzl4i6k6gmkrhxxbm6cdq1na'';
  };

  packageName = "log4cl";

  asdFilesToKeep = ["log4cl.asd"];
  overrides = x: x;
}
/* (SYSTEM log4cl DESCRIPTION System lacks description SHA256
    0i4i4ahw13fzka8ixasv292y59ljyzl4i6k6gmkrhxxbm6cdq1na URL
    http://beta.quicklisp.org/archive/log4cl/2019-10-07/log4cl-20191007-git.tgz
    MD5 11cdcd9da0ede86092886a055b186861 NAME log4cl FILENAME log4cl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads stefil) VERSION 20191007-git
    SIBLINGS (log4cl-examples log4slime) PARASITES (log4cl/syslog log4cl/test)) */
