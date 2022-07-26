/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-qrencode";
  version = "20191007-git";

  description = "QR code 2005 encoder in Common Lisp";

  deps = [ args."salza2" args."trivial-gray-streams" args."zpng" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-qrencode/2019-10-07/cl-qrencode-20191007-git.tgz";
    sha256 = "0jc4bmw498bxkw5imvsj4p49njyybsjhbbvnmykivc38k5nlypz4";
  };

  packageName = "cl-qrencode";

  asdFilesToKeep = ["cl-qrencode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-qrencode DESCRIPTION QR code 2005 encoder in Common Lisp SHA256
    0jc4bmw498bxkw5imvsj4p49njyybsjhbbvnmykivc38k5nlypz4 URL
    http://beta.quicklisp.org/archive/cl-qrencode/2019-10-07/cl-qrencode-20191007-git.tgz
    MD5 e94ac1137949ef70dea11ca78431e956 NAME cl-qrencode FILENAME cl-qrencode
    DEPS
    ((NAME salza2 FILENAME salza2)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME zpng FILENAME zpng))
    DEPENDENCIES (salza2 trivial-gray-streams zpng) VERSION 20191007-git
    SIBLINGS (cl-qrencode-test) PARASITES NIL) */
