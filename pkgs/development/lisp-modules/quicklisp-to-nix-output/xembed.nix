args @ { fetchurl, ... }:
rec {
  baseName = ''xembed'';
  version = ''clx-20190307-git'';

  description = ''An implementation of the XEMBED protocol that integrates with CLX.'';

  deps = [ args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx-xembed/2019-03-07/clx-xembed-20190307-git.tgz'';
    sha256 = ''1a0yy707qdb7sw20lavmhlass3n3ds2pn52jxdkrvpgg358waf3j'';
  };

  packageName = "xembed";

  asdFilesToKeep = ["xembed.asd"];
  overrides = x: x;
}
/* (SYSTEM xembed DESCRIPTION
    An implementation of the XEMBED protocol that integrates with CLX. SHA256
    1a0yy707qdb7sw20lavmhlass3n3ds2pn52jxdkrvpgg358waf3j URL
    http://beta.quicklisp.org/archive/clx-xembed/2019-03-07/clx-xembed-20190307-git.tgz
    MD5 04304f828ea8970b6f5301fe78ed8e10 NAME xembed FILENAME xembed DEPS
    ((NAME clx FILENAME clx)) DEPENDENCIES (clx) VERSION clx-20190307-git
    SIBLINGS NIL PARASITES NIL) */
