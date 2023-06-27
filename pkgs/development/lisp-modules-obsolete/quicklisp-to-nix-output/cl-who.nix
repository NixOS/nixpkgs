/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-who";
  version = "20190710-git";

  parasites = [ "cl-who-test" ];

  description = "(X)HTML generation macros";

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-who/2019-07-10/cl-who-20190710-git.tgz";
    sha256 = "0pbigwn38xikdwvjy9696z9f00dwg565y3wh6ja51q681y8zh9ir";
  };

  packageName = "cl-who";

  asdFilesToKeep = ["cl-who.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-who DESCRIPTION (X)HTML generation macros SHA256
    0pbigwn38xikdwvjy9696z9f00dwg565y3wh6ja51q681y8zh9ir URL
    http://beta.quicklisp.org/archive/cl-who/2019-07-10/cl-who-20190710-git.tgz
    MD5 e5bb2856ed62d76528e4cef7b5e701c0 NAME cl-who FILENAME cl-who DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 20190710-git SIBLINGS NIL PARASITES (cl-who-test)) */
