args @ { fetchurl, ... }:
rec {
  baseName = ''chipz'';
  version = ''20180328-git'';

  description = ''A library for decompressing deflate, zlib, and gzip data'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chipz/2018-03-28/chipz-20180328-git.tgz'';
    sha256 = ''0ryjrfrlzyjkzb799indyzxivq8s9d7pgjzss7ha91xzr8sl6xf7'';
  };

  packageName = "chipz";

  asdFilesToKeep = ["chipz.asd"];
  overrides = x: x;
}
/* (SYSTEM chipz DESCRIPTION
    A library for decompressing deflate, zlib, and gzip data SHA256
    0ryjrfrlzyjkzb799indyzxivq8s9d7pgjzss7ha91xzr8sl6xf7 URL
    http://beta.quicklisp.org/archive/chipz/2018-03-28/chipz-20180328-git.tgz
    MD5 a548809d6ef705c69356a2057ecd8a52 NAME chipz FILENAME chipz DEPS NIL
    DEPENDENCIES NIL VERSION 20180328-git SIBLINGS NIL PARASITES NIL) */
