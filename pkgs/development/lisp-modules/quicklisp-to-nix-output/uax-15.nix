/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uax-15";
  version = "20211020-git";

  parasites = [ "uax-15/tests" ];

  description = "Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)";

  deps = [ args."cl-ppcre" args."parachute" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uax-15/2021-10-20/uax-15-20211020-git.tgz";
    sha256 = "1g6mbwxv8cbv9gbpkj267lwdgq8k21qx0isy1gbrc158h0al7bp9";
  };

  packageName = "uax-15";

  asdFilesToKeep = ["uax-15.asd"];
  overrides = x: x;
}
/* (SYSTEM uax-15 DESCRIPTION
    Common lisp implementation of Unicode normalization functions :nfc, :nfd, :nfkc and :nfkd (Uax-15)
    SHA256 1g6mbwxv8cbv9gbpkj267lwdgq8k21qx0isy1gbrc158h0al7bp9 URL
    http://beta.quicklisp.org/archive/uax-15/2021-10-20/uax-15-20211020-git.tgz
    MD5 27503fd1e91e494cc9ac10a985dbf95e NAME uax-15 FILENAME uax-15 DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME parachute FILENAME parachute)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (cl-ppcre parachute split-sequence) VERSION 20211020-git
    SIBLINGS NIL PARASITES (uax-15/tests)) */
