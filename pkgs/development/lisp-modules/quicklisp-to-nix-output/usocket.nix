args @ { fetchurl, ... }:
{
  baseName = ''usocket'';
  version = ''0.8.2'';

  description = ''Universal socket library for Common Lisp'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/usocket/2019-07-10/usocket-0.8.2.tgz'';
    sha256 = ''0g5niqwzh4y6f25lnjx1qyzl0yg906zq2sy7ck67f7bcmc79w8zm'';
  };

  packageName = "usocket";

  asdFilesToKeep = ["usocket.asd"];
  overrides = x: x;
}
/* (SYSTEM usocket DESCRIPTION Universal socket library for Common Lisp SHA256
    0g5niqwzh4y6f25lnjx1qyzl0yg906zq2sy7ck67f7bcmc79w8zm URL
    http://beta.quicklisp.org/archive/usocket/2019-07-10/usocket-0.8.2.tgz MD5
    0218443cd70b675d9b09c1bf09cd9da4 NAME usocket FILENAME usocket DEPS
    ((NAME split-sequence FILENAME split-sequence)) DEPENDENCIES
    (split-sequence) VERSION 0.8.2 SIBLINGS (usocket-server usocket-test)
    PARASITES NIL) */
