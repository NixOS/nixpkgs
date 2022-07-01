/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "map-set";
  version = "20190307-hg";

  description = "Set-like data structure.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/map-set/2019-03-07/map-set-20190307-hg.tgz";
    sha256 = "1x7yh4gzdvypr1q45qgmjln5pjlh82bfpk6sqyrihrldmwwnbzg9";
  };

  packageName = "map-set";

  asdFilesToKeep = ["map-set.asd"];
  overrides = x: x;
}
/* (SYSTEM map-set DESCRIPTION Set-like data structure. SHA256
    1x7yh4gzdvypr1q45qgmjln5pjlh82bfpk6sqyrihrldmwwnbzg9 URL
    http://beta.quicklisp.org/archive/map-set/2019-03-07/map-set-20190307-hg.tgz
    MD5 866dba36cdf060c943267cb79ccc0532 NAME map-set FILENAME map-set DEPS NIL
    DEPENDENCIES NIL VERSION 20190307-hg SIBLINGS NIL PARASITES NIL) */
