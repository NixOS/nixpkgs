args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20190521-git'';

  parasites = [ "clx/test" ];

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2019-05-21/clx-20190521-git.tgz'';
    sha256 = ''0rsais9nsz4naf50wp2iirxfj84rdmbdxivfh3496rsi2ji7j8qs'';
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    0rsais9nsz4naf50wp2iirxfj84rdmbdxivfh3496rsi2ji7j8qs URL
    http://beta.quicklisp.org/archive/clx/2019-05-21/clx-20190521-git.tgz MD5
    afcd581193237d3202a4fbcc1f0622c3 NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20190521-git
    SIBLINGS NIL PARASITES (clx/test)) */
