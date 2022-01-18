/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clunit2";
  version = "20211020-git";

  description = "CLUnit is a Common Lisp unit testing framework.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clunit2/2021-10-20/clunit2-20211020-git.tgz";
    sha256 = "0qly5gk1fn0bd0kx6spdhmnsf58gdg19py46w10p5vvs41vvriy3";
  };

  packageName = "clunit2";

  asdFilesToKeep = ["clunit2.asd"];
  overrides = x: x;
}
/* (SYSTEM clunit2 DESCRIPTION CLUnit is a Common Lisp unit testing framework.
    SHA256 0qly5gk1fn0bd0kx6spdhmnsf58gdg19py46w10p5vvs41vvriy3 URL
    http://beta.quicklisp.org/archive/clunit2/2021-10-20/clunit2-20211020-git.tgz
    MD5 0ee5b2d53c81e9640d3aa8c904b0b236 NAME clunit2 FILENAME clunit2 DEPS NIL
    DEPENDENCIES NIL VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
