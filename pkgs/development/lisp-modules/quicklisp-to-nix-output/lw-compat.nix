/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lw-compat";
  version = "20160318-git";

  description = "A few utility functions from the LispWorks library that are used in the Closer to MOP libraries.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lw-compat/2016-03-18/lw-compat-20160318-git.tgz";
    sha256 = "10p5w6xga79z9nqcmp364ng76ik80ipy5m1cjgf6bah4ivrbn56q";
  };

  packageName = "lw-compat";

  asdFilesToKeep = ["lw-compat.asd"];
  overrides = x: x;
}
/* (SYSTEM lw-compat DESCRIPTION
    A few utility functions from the LispWorks library that are used in the Closer to MOP libraries.
    SHA256 10p5w6xga79z9nqcmp364ng76ik80ipy5m1cjgf6bah4ivrbn56q URL
    http://beta.quicklisp.org/archive/lw-compat/2016-03-18/lw-compat-20160318-git.tgz
    MD5 024b8e63d13fb12dbcccaf18cf4f8dfa NAME lw-compat FILENAME lw-compat DEPS
    NIL DEPENDENCIES NIL VERSION 20160318-git SIBLINGS NIL PARASITES NIL) */
