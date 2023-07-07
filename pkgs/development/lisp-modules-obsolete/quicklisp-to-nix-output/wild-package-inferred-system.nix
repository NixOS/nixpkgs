/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "wild-package-inferred-system";
  version = "20200325-git";

  parasites = [ "wild-package-inferred-system/test" ];

  description = "Introduces the wildcards `*' and `**' into package-inferred-system";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/wild-package-inferred-system/2020-03-25/wild-package-inferred-system-20200325-git.tgz";
    sha256 = "1ypnpzy9z4zkna29sgl4afc386ksa61302bm5kznxb3zz2v1sjas";
  };

  packageName = "wild-package-inferred-system";

  asdFilesToKeep = ["wild-package-inferred-system.asd"];
  overrides = x: x;
}
/* (SYSTEM wild-package-inferred-system DESCRIPTION
    Introduces the wildcards `*' and `**' into package-inferred-system SHA256
    1ypnpzy9z4zkna29sgl4afc386ksa61302bm5kznxb3zz2v1sjas URL
    http://beta.quicklisp.org/archive/wild-package-inferred-system/2020-03-25/wild-package-inferred-system-20200325-git.tgz
    MD5 4dfd9f90d780b1e67640543dd4acbf21 NAME wild-package-inferred-system
    FILENAME wild-package-inferred-system DEPS ((NAME fiveam FILENAME fiveam))
    DEPENDENCIES (fiveam) VERSION 20200325-git SIBLINGS (foo-wild) PARASITES
    (wild-package-inferred-system/test)) */
