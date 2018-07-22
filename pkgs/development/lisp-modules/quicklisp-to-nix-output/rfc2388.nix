{ fetchurl, ... }:
rec {
  baseName = ''rfc2388'';
  version = ''20130720-git'';

  description = ''Implementation of RFC 2388'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/rfc2388/2013-07-20/rfc2388-20130720-git.tgz'';
    sha256 = ''1ky99cr4bgfyh0pfpl5f6fsmq1qdbgi4b8v0cfs4y73f78p1f8b6'';
  };

  packageName = "rfc2388";

  asdFilesToKeep = ["rfc2388.asd"];
  overrides = x: x;
}
/* (SYSTEM rfc2388 DESCRIPTION Implementation of RFC 2388 SHA256
    1ky99cr4bgfyh0pfpl5f6fsmq1qdbgi4b8v0cfs4y73f78p1f8b6 URL
    http://beta.quicklisp.org/archive/rfc2388/2013-07-20/rfc2388-20130720-git.tgz
    MD5 10a8bfea588196b1147d5dc7bf759bb1 NAME rfc2388 FILENAME rfc2388 DEPS NIL
    DEPENDENCIES NIL VERSION 20130720-git SIBLINGS NIL PARASITES NIL) */
