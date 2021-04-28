/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "log4cl";
  version = "20200925-git";

  parasites = [ "log4cl/syslog" "log4cl/test" ];

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."stefil" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/log4cl/2020-09-25/log4cl-20200925-git.tgz";
    sha256 = "1z98ly71hsbd46i0dqqv2s3cm9y8bi0pl3yg8a168vz629c6mdrf";
  };

  packageName = "log4cl";

  asdFilesToKeep = ["log4cl.asd"];
  overrides = x: x;
}
/* (SYSTEM log4cl DESCRIPTION System lacks description SHA256
    1z98ly71hsbd46i0dqqv2s3cm9y8bi0pl3yg8a168vz629c6mdrf URL
    http://beta.quicklisp.org/archive/log4cl/2020-09-25/log4cl-20200925-git.tgz
    MD5 80b347666af496142581e9e0c029d181 NAME log4cl FILENAME log4cl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads stefil) VERSION 20200925-git
    SIBLINGS (log4cl-examples log4slime) PARASITES (log4cl/syslog log4cl/test)) */
