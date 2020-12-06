args @ { fetchurl, ... }:
rec {
  baseName = ''cl-aa'';
  version = ''cl-vectors-20180228-git'';

  description = ''cl-aa: polygon rasterizer'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2018-02-28/cl-vectors-20180228-git.tgz'';
    sha256 = ''0fcypjfzqra8ryb4nx1vx1fqy7fwvyz3f443qkjg2z81akhkscly'';
  };

  packageName = "cl-aa";

  asdFilesToKeep = ["cl-aa.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-aa DESCRIPTION cl-aa: polygon rasterizer SHA256
    0fcypjfzqra8ryb4nx1vx1fqy7fwvyz3f443qkjg2z81akhkscly URL
    http://beta.quicklisp.org/archive/cl-vectors/2018-02-28/cl-vectors-20180228-git.tgz
    MD5 9d9629786d4f2c19c15cc6cd3049c343 NAME cl-aa FILENAME cl-aa DEPS NIL
    DEPENDENCIES NIL VERSION cl-vectors-20180228-git SIBLINGS
    (cl-aa-misc cl-paths-ttf cl-paths cl-vectors) PARASITES NIL) */
