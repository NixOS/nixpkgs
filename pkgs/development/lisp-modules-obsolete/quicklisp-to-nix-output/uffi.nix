/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uffi";
  version = "20180228-git";

  description = "Universal Foreign Function Library for Common Lisp";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uffi/2018-02-28/uffi-20180228-git.tgz";
    sha256 = "1kknzwxsbg2ydy2w0n88y2bq37lqqwg02ffsmz57gqbxvlk26479";
  };

  packageName = "uffi";

  asdFilesToKeep = ["uffi.asd"];
  overrides = x: x;
}
/* (SYSTEM uffi DESCRIPTION Universal Foreign Function Library for Common Lisp
    SHA256 1kknzwxsbg2ydy2w0n88y2bq37lqqwg02ffsmz57gqbxvlk26479 URL
    http://beta.quicklisp.org/archive/uffi/2018-02-28/uffi-20180228-git.tgz MD5
    b0dfb2f966912f4797327948aa7e9119 NAME uffi FILENAME uffi DEPS NIL
    DEPENDENCIES NIL VERSION 20180228-git SIBLINGS (uffi-tests) PARASITES NIL) */
