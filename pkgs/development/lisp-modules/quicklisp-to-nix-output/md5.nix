args @ { fetchurl, ... }:
rec {
  baseName = ''md5'';
  version = ''20170630-git'';

  description = ''The MD5 Message-Digest Algorithm RFC 1321'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/md5/2017-06-30/md5-20170630-git.tgz'';
    sha256 = ''0pli483skkfbi9ln8ghxnvzw9p5srs8zyilkygsimkzy8fcc5hyx'';
  };

  packageName = "md5";

  asdFilesToKeep = ["md5.asd"];
  overrides = x: x;
}
/* (SYSTEM md5 DESCRIPTION The MD5 Message-Digest Algorithm RFC 1321 SHA256
    0pli483skkfbi9ln8ghxnvzw9p5srs8zyilkygsimkzy8fcc5hyx URL
    http://beta.quicklisp.org/archive/md5/2017-06-30/md5-20170630-git.tgz MD5
    c6a5b3ca5a23fad3dfde23963db84910 NAME md5 FILENAME md5 DEPS NIL
    DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL PARASITES NIL) */
