/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "log4cl";
  version = "20211209-git";

  parasites = [ "log4cl/syslog" "log4cl/test" ];

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."stefil" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/log4cl/2021-12-09/log4cl-20211209-git.tgz";
    sha256 = "17jwxhc2ysh3m3cp7wvh8cy359v7w6kz9vk9f07japzi3krv9iq9";
  };

  packageName = "log4cl";

  asdFilesToKeep = ["log4cl.asd"];
  overrides = x: x;
}
/* (SYSTEM log4cl DESCRIPTION System lacks description SHA256
    17jwxhc2ysh3m3cp7wvh8cy359v7w6kz9vk9f07japzi3krv9iq9 URL
    http://beta.quicklisp.org/archive/log4cl/2021-12-09/log4cl-20211209-git.tgz
    MD5 569122fed30c089b67527926468dcf44 NAME log4cl FILENAME log4cl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads stefil) VERSION 20211209-git
    SIBLINGS (log4cl-examples log4cl.log4slime log4cl.log4sly) PARASITES
    (log4cl/syslog log4cl/test)) */
