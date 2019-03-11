args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20181018-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2018-10-18/trivial-indent-20181018-git.tgz'';
    sha256 = ''0lrbzm1dsf28q7vh9g8n8i5gzd5lxzfaphsa5dd9k2ahdr912c2g'';
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    0lrbzm1dsf28q7vh9g8n8i5gzd5lxzfaphsa5dd9k2ahdr912c2g URL
    http://beta.quicklisp.org/archive/trivial-indent/2018-10-18/trivial-indent-20181018-git.tgz
    MD5 87679f984544027ac939c22e288b09c5 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20181018-git SIBLINGS NIL
    PARASITES NIL) */
