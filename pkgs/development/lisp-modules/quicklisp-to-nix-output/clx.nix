args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20171227-git'';

  parasites = [ "clx/test" ];

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2017-12-27/clx-20171227-git.tgz'';
    sha256 = ''159kwwilyvaffjdz7sbwwd4cncfa8kxndc7n3adml9ivbvaz2wri'';
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    159kwwilyvaffjdz7sbwwd4cncfa8kxndc7n3adml9ivbvaz2wri URL
    http://beta.quicklisp.org/archive/clx/2017-12-27/clx-20171227-git.tgz MD5
    40642f49e26b88859376efe2e5330a24 NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20171227-git
    SIBLINGS NIL PARASITES (clx/test)) */
