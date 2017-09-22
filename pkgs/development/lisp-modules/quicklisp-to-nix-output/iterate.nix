args @ { fetchurl, ... }:
rec {
  baseName = ''iterate'';
  version = ''20160825-darcs'';

  parasites = [ "iterate/tests" ];

  description = ''Jonathan Amsterdam's iterator/gatherer/accumulator facility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iterate/2016-08-25/iterate-20160825-darcs.tgz'';
    sha256 = ''0kvz16gnxnkdz0fy1x8y5yr28nfm7i2qpvix7mgwccdpjmsb4pgm'';
  };

  packageName = "iterate";

  asdFilesToKeep = ["iterate.asd"];
  overrides = x: x;
}
/* (SYSTEM iterate DESCRIPTION
    Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256
    0kvz16gnxnkdz0fy1x8y5yr28nfm7i2qpvix7mgwccdpjmsb4pgm URL
    http://beta.quicklisp.org/archive/iterate/2016-08-25/iterate-20160825-darcs.tgz
    MD5 e73ff4898ce4831ff2a28817f32de86e NAME iterate FILENAME iterate DEPS NIL
    DEPENDENCIES NIL VERSION 20160825-darcs SIBLINGS NIL PARASITES
    (iterate/tests)) */
