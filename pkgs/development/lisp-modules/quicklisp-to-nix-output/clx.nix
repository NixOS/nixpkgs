/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clx";
  version = "20200715-git";

  parasites = [ "clx/test" ];

  description = "An implementation of the X Window System protocol in Lisp.";

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clx/2020-07-15/clx-20200715-git.tgz";
    sha256 = "1fvx6m3imvkkd0z5a3jmm2v6mkrndwsidhykrs229rqx343zg8ra";
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    1fvx6m3imvkkd0z5a3jmm2v6mkrndwsidhykrs229rqx343zg8ra URL
    http://beta.quicklisp.org/archive/clx/2020-07-15/clx-20200715-git.tgz MD5
    c0e08c88e78587bdbbbea188848dc39d NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20200715-git
    SIBLINGS NIL PARASITES (clx/test)) */
