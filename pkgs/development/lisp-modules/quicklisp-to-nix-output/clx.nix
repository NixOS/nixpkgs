args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20180430-git'';

  parasites = [ "clx/test" ];

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2018-04-30/clx-20180430-git.tgz'';
    sha256 = ''18ghhirnx0js7q1samwyah990nmgqbas7b1y0wy0fqynaznaz9x3'';
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    18ghhirnx0js7q1samwyah990nmgqbas7b1y0wy0fqynaznaz9x3 URL
    http://beta.quicklisp.org/archive/clx/2018-04-30/clx-20180430-git.tgz MD5
    bf9c1d6b1b2856ddbd4bf2fa75bbc309 NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20180430-git
    SIBLINGS NIL PARASITES (clx/test)) */
