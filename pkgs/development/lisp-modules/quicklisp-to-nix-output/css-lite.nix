/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "css-lite";
  version = "20120407-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/css-lite/2012-04-07/css-lite-20120407-git.tgz";
    sha256 = "1gf1qqaxhly6ixh9ykqhg9b52s8p5wlwi46vp2k29qy7gmx4f1qg";
  };

  packageName = "css-lite";

  asdFilesToKeep = ["css-lite.asd"];
  overrides = x: x;
}
/* (SYSTEM css-lite DESCRIPTION System lacks description SHA256
    1gf1qqaxhly6ixh9ykqhg9b52s8p5wlwi46vp2k29qy7gmx4f1qg URL
    http://beta.quicklisp.org/archive/css-lite/2012-04-07/css-lite-20120407-git.tgz
    MD5 9b25afb0d2c3f0c32d2303ab1d3f570d NAME css-lite FILENAME css-lite DEPS
    NIL DEPENDENCIES NIL VERSION 20120407-git SIBLINGS NIL PARASITES NIL) */
