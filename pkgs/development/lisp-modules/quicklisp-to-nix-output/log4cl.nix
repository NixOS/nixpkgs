args @ { fetchurl, ... }:
rec {
  baseName = ''log4cl'';
  version = ''20190107-git'';

  parasites = [ "log4cl/syslog" "log4cl/test" ];

  description = ''System lacks description'';

  deps = [ args."alexandria" args."bordeaux-threads" args."stefil" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/log4cl/2019-01-07/log4cl-20190107-git.tgz'';
    sha256 = ''0c5gsmz69jby5hmcl4igf1sh6xkwh8bx2jz6kd2gcnqjwq37h46p'';
  };

  packageName = "log4cl";

  asdFilesToKeep = ["log4cl.asd"];
  overrides = x: x;
}
/* (SYSTEM log4cl DESCRIPTION System lacks description SHA256
    0c5gsmz69jby5hmcl4igf1sh6xkwh8bx2jz6kd2gcnqjwq37h46p URL
    http://beta.quicklisp.org/archive/log4cl/2019-01-07/log4cl-20190107-git.tgz
    MD5 ecfa1f67902c776f46d192acd55f628c NAME log4cl FILENAME log4cl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads stefil) VERSION 20190107-git
    SIBLINGS (log4cl-examples log4slime) PARASITES (log4cl/syslog log4cl/test)) */
