args @ { fetchurl, ... }:
rec {
  baseName = ''stefil'';
  version = ''20101107-darcs'';

  parasites = [ "stefil-test" ];

  description = ''Stefil - Simple Test Framework In Lisp'';

  deps = [ args."alexandria" args."iterate" args."metabang-bind" args."swank" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stefil/2010-11-07/stefil-20101107-darcs.tgz'';
    sha256 = ''0d81js0p02plv7wy1640xmghb4s06gay76pqw2k3dnamkglcglz3'';
  };

  packageName = "stefil";

  asdFilesToKeep = ["stefil.asd"];
  overrides = x: x;
}
/* (SYSTEM stefil DESCRIPTION Stefil - Simple Test Framework In Lisp SHA256
    0d81js0p02plv7wy1640xmghb4s06gay76pqw2k3dnamkglcglz3 URL
    http://beta.quicklisp.org/archive/stefil/2010-11-07/stefil-20101107-darcs.tgz
    MD5 8c56bc03e7679e4d42bb3bb3b101de80 NAME stefil FILENAME stefil DEPS
    ((NAME alexandria FILENAME alexandria) (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank))
    DEPENDENCIES (alexandria iterate metabang-bind swank) VERSION
    20101107-darcs SIBLINGS NIL PARASITES (stefil-test)) */
