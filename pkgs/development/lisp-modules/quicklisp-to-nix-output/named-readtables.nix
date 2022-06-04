/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "named-readtables";
  version = "20220220-git";

  parasites = [ "named-readtables/test" ];

  description = "Library that creates a namespace for readtables akin
  to the namespace of packages.";

  deps = [ args."try" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/named-readtables/2022-02-20/named-readtables-20220220-git.tgz";
    sha256 = "1mhwm8flks3g38bbx33crw862mn80i98mqd6jc7hx8ka42zbr1dk";
  };

  packageName = "named-readtables";

  asdFilesToKeep = ["named-readtables.asd"];
  overrides = x: x;
}
/* (SYSTEM named-readtables DESCRIPTION
    Library that creates a namespace for readtables akin
  to the namespace of packages.
    SHA256 1mhwm8flks3g38bbx33crw862mn80i98mqd6jc7hx8ka42zbr1dk URL
    http://beta.quicklisp.org/archive/named-readtables/2022-02-20/named-readtables-20220220-git.tgz
    MD5 3505b527d172099c5c7d0b4665081eec NAME named-readtables FILENAME
    named-readtables DEPS ((NAME try FILENAME try)) DEPENDENCIES (try) VERSION
    20220220-git SIBLINGS NIL PARASITES (named-readtables/test)) */
