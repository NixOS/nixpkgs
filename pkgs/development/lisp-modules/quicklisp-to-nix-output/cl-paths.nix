/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-paths";
  version = "cl-vectors-20180228-git";

  description = "cl-paths: vectorial paths manipulation";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-vectors/2018-02-28/cl-vectors-20180228-git.tgz";
    sha256 = "0fcypjfzqra8ryb4nx1vx1fqy7fwvyz3f443qkjg2z81akhkscly";
  };

  packageName = "cl-paths";

  asdFilesToKeep = ["cl-paths.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-paths DESCRIPTION cl-paths: vectorial paths manipulation SHA256
    0fcypjfzqra8ryb4nx1vx1fqy7fwvyz3f443qkjg2z81akhkscly URL
    http://beta.quicklisp.org/archive/cl-vectors/2018-02-28/cl-vectors-20180228-git.tgz
    MD5 9d9629786d4f2c19c15cc6cd3049c343 NAME cl-paths FILENAME cl-paths DEPS
    NIL DEPENDENCIES NIL VERSION cl-vectors-20180228-git SIBLINGS
    (cl-aa-misc cl-aa cl-paths-ttf cl-vectors) PARASITES NIL) */
