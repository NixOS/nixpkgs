args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20180711-git'';

  parasites = [ "clx/test" ];

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2018-07-11/clx-20180711-git.tgz'';
    sha256 = ''0vpavllapc0j6j7iwxpxzgl8n5krvrwhmd5k2k0f3pr6sgl1y29h'';
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    0vpavllapc0j6j7iwxpxzgl8n5krvrwhmd5k2k0f3pr6sgl1y29h URL
    http://beta.quicklisp.org/archive/clx/2018-07-11/clx-20180711-git.tgz MD5
    27d5e904d2b7e4cdf4e8492839d15bad NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20180711-git
    SIBLINGS NIL PARASITES (clx/test)) */
