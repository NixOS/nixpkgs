/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-paths-ttf";
  version = "cl-vectors-20180228-git";

  description = "cl-paths-ttf: vectorial paths manipulation";

  deps = [ args."cl-paths" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-vectors/2018-02-28/cl-vectors-20180228-git.tgz";
    sha256 = "0fcypjfzqra8ryb4nx1vx1fqy7fwvyz3f443qkjg2z81akhkscly";
  };

  packageName = "cl-paths-ttf";

  asdFilesToKeep = ["cl-paths-ttf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-paths-ttf DESCRIPTION cl-paths-ttf: vectorial paths manipulation
    SHA256 0fcypjfzqra8ryb4nx1vx1fqy7fwvyz3f443qkjg2z81akhkscly URL
    http://beta.quicklisp.org/archive/cl-vectors/2018-02-28/cl-vectors-20180228-git.tgz
    MD5 9d9629786d4f2c19c15cc6cd3049c343 NAME cl-paths-ttf FILENAME
    cl-paths-ttf DEPS
    ((NAME cl-paths FILENAME cl-paths) (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (cl-paths zpb-ttf) VERSION cl-vectors-20180228-git SIBLINGS
    (cl-aa-misc cl-aa cl-paths cl-vectors) PARASITES NIL) */
