/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uax-15";
  version = "20210531-git";

  parasites = [ "uax-15/tests" ];

  description = "Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)";

  deps = [ args."cl-ppcre" args."parachute" args."split-sequence" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uax-15/2021-05-31/uax-15-20210531-git.tgz";
    sha256 = "0yz4zi13iybpwa2bw5r6cjdbkw1njrbb6vgjwmm3msnl1paxr3wg";
  };

  packageName = "uax-15";

  asdFilesToKeep = ["uax-15.asd"];
  overrides = x: x;
}
/* (SYSTEM uax-15 DESCRIPTION
    Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)
    SHA256 0yz4zi13iybpwa2bw5r6cjdbkw1njrbb6vgjwmm3msnl1paxr3wg URL
    http://beta.quicklisp.org/archive/uax-15/2021-05-31/uax-15-20210531-git.tgz
    MD5 bceff07d037c7daccbdd5c84683fcddd NAME uax-15 FILENAME uax-15 DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME parachute FILENAME parachute)
     (NAME split-sequence FILENAME split-sequence) (NAME uiop FILENAME uiop))
    DEPENDENCIES (cl-ppcre parachute split-sequence uiop) VERSION 20210531-git
    SIBLINGS NIL PARASITES (uax-15/tests)) */
