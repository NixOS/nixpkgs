/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "xembed";
  version = "clx-20191130-git";

  description = "An implementation of the XEMBED protocol that integrates with CLX.";

  deps = [ args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clx-xembed/2019-11-30/clx-xembed-20191130-git.tgz";
    sha256 = "1ik5gxzhn9j7827jg6g8rk2wa5jby11n2db24y6wrf0ldnbpj7jd";
  };

  packageName = "xembed";

  asdFilesToKeep = ["xembed.asd"];
  overrides = x: x;
}
/* (SYSTEM xembed DESCRIPTION
    An implementation of the XEMBED protocol that integrates with CLX. SHA256
    1ik5gxzhn9j7827jg6g8rk2wa5jby11n2db24y6wrf0ldnbpj7jd URL
    http://beta.quicklisp.org/archive/clx-xembed/2019-11-30/clx-xembed-20191130-git.tgz
    MD5 11d35eeb734c0694005a5e5cec4cad22 NAME xembed FILENAME xembed DEPS
    ((NAME clx FILENAME clx)) DEPENDENCIES (clx) VERSION clx-20191130-git
    SIBLINGS NIL PARASITES NIL) */
