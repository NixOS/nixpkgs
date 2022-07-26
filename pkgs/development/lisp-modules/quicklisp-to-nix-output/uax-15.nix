/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uax-15";
  version = "20211209-git";

  parasites = [ "uax-15/tests" ];

  description = "Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)";

  deps = [ args."cl-ppcre" args."parachute" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uax-15/2021-12-09/uax-15-20211209-git.tgz";
    sha256 = "0haqp2vgnwq6p4j44xz0xzz4lcf15pj3pla4ybnpral2218j2cdz";
  };

  packageName = "uax-15";

  asdFilesToKeep = ["uax-15.asd"];
  overrides = x: x;
}
/* (SYSTEM uax-15 DESCRIPTION
    Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)
    SHA256 0haqp2vgnwq6p4j44xz0xzz4lcf15pj3pla4ybnpral2218j2cdz URL
    http://beta.quicklisp.org/archive/uax-15/2021-12-09/uax-15-20211209-git.tgz
    MD5 431f4e399305c7ed8d3ce151ea6ff132 NAME uax-15 FILENAME uax-15 DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME parachute FILENAME parachute)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (cl-ppcre parachute split-sequence) VERSION 20211209-git
    SIBLINGS NIL PARASITES (uax-15/tests)) */
