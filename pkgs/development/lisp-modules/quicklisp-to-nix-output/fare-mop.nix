/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fare-mop";
  version = "20151218-git";

  description = "Utilities using the MOP; notably make informative pretty-printing trivial";

  deps = [ args."closer-mop" args."fare-utils" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fare-mop/2015-12-18/fare-mop-20151218-git.tgz";
    sha256 = "0bvrwqvacy114xsblrk2w28qk6b484a3p0w14mzl264b3wjrdna9";
  };

  packageName = "fare-mop";

  asdFilesToKeep = ["fare-mop.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-mop DESCRIPTION
    Utilities using the MOP; notably make informative pretty-printing trivial
    SHA256 0bvrwqvacy114xsblrk2w28qk6b484a3p0w14mzl264b3wjrdna9 URL
    http://beta.quicklisp.org/archive/fare-mop/2015-12-18/fare-mop-20151218-git.tgz
    MD5 4721ff62e2ac2c55079cdd4f2a0f6d4a NAME fare-mop FILENAME fare-mop DEPS
    ((NAME closer-mop FILENAME closer-mop)
     (NAME fare-utils FILENAME fare-utils))
    DEPENDENCIES (closer-mop fare-utils) VERSION 20151218-git SIBLINGS NIL
    PARASITES NIL) */
