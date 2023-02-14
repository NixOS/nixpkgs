/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "wild-package-inferred-system";
  version = "20210531-git";

  parasites = [ "wild-package-inferred-system/test" ];

  description = "Introduces the wildcards `*' and `**' into package-inferred-system";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/wild-package-inferred-system/2021-05-31/wild-package-inferred-system-20210531-git.tgz";
    sha256 = "1ads1hyq9zs1w2pp4i9drmpkpz7kwwszmhi340a6wjm120lfb6kk";
  };

  packageName = "wild-package-inferred-system";

  asdFilesToKeep = ["wild-package-inferred-system.asd"];
  overrides = x: x;
}
/* (SYSTEM wild-package-inferred-system DESCRIPTION
    Introduces the wildcards `*' and `**' into package-inferred-system SHA256
    1ads1hyq9zs1w2pp4i9drmpkpz7kwwszmhi340a6wjm120lfb6kk URL
    http://beta.quicklisp.org/archive/wild-package-inferred-system/2021-05-31/wild-package-inferred-system-20210531-git.tgz
    MD5 4744e08ef5f50da04a429ae9af60bb80 NAME wild-package-inferred-system
    FILENAME wild-package-inferred-system DEPS ((NAME fiveam FILENAME fiveam))
    DEPENDENCIES (fiveam) VERSION 20210531-git SIBLINGS (foo-wild) PARASITES
    (wild-package-inferred-system/test)) */
