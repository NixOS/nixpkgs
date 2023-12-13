/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "jpl-util";
  version = "cl-20151031-git";

  description = "Sundry utilities for J.P. Larocque.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-jpl-util/2015-10-31/cl-jpl-util-20151031-git.tgz";
    sha256 = "1a3sfamgrqgsf0ql3fkbpmjbs837v1b3nxqxp4mkisp6yxanmhzx";
  };

  packageName = "jpl-util";

  asdFilesToKeep = ["jpl-util.asd"];
  overrides = x: x;
}
/* (SYSTEM jpl-util DESCRIPTION Sundry utilities for J.P. Larocque. SHA256
    1a3sfamgrqgsf0ql3fkbpmjbs837v1b3nxqxp4mkisp6yxanmhzx URL
    http://beta.quicklisp.org/archive/cl-jpl-util/2015-10-31/cl-jpl-util-20151031-git.tgz
    MD5 e294bedace729724873e7633b8265a00 NAME jpl-util FILENAME jpl-util DEPS
    NIL DEPENDENCIES NIL VERSION cl-20151031-git SIBLINGS NIL PARASITES NIL) */
