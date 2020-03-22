args @ { fetchurl, ... }:
rec {
  baseName = ''swap-bytes'';
  version = ''v1.2'';

  parasites = [ "swap-bytes/test" ];

  description = ''Optimized byte-swapping primitives.'';

  deps = [ args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/swap-bytes/2019-11-30/swap-bytes-v1.2.tgz'';
    sha256 = ''05g37m4cpsszh16jz7kiscd6m6l66ms73f3s6s94i56c49jfxdy8'';
  };

  packageName = "swap-bytes";

  asdFilesToKeep = ["swap-bytes.asd"];
  overrides = x: x;
}
/* (SYSTEM swap-bytes DESCRIPTION Optimized byte-swapping primitives. SHA256
    05g37m4cpsszh16jz7kiscd6m6l66ms73f3s6s94i56c49jfxdy8 URL
    http://beta.quicklisp.org/archive/swap-bytes/2019-11-30/swap-bytes-v1.2.tgz
    MD5 eea516d7fdbe20bc963a6708c225d719 NAME swap-bytes FILENAME swap-bytes
    DEPS
    ((NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (fiveam trivial-features) VERSION v1.2 SIBLINGS NIL PARASITES
    (swap-bytes/test)) */
