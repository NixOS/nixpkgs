args @ { fetchurl, ... }:
{
  baseName = ''swap-bytes'';
  version = ''v1.1'';

  parasites = [ "swap-bytes/test" ];

  description = ''Optimized byte-swapping primitives.'';

  deps = [ args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/swap-bytes/2016-09-29/swap-bytes-v1.1.tgz'';
    sha256 = ''0snwbfplqhg1y4y4m7lgvksg1hs0sygfikz3rlbkfl4gwg8pq8ky'';
  };

  packageName = "swap-bytes";

  asdFilesToKeep = ["swap-bytes.asd"];
  overrides = x: x;
}
/* (SYSTEM swap-bytes DESCRIPTION Optimized byte-swapping primitives. SHA256
    0snwbfplqhg1y4y4m7lgvksg1hs0sygfikz3rlbkfl4gwg8pq8ky URL
    http://beta.quicklisp.org/archive/swap-bytes/2016-09-29/swap-bytes-v1.1.tgz
    MD5 dda8b3b0a4e345879e80a3cc398667bb NAME swap-bytes FILENAME swap-bytes
    DEPS
    ((NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (fiveam trivial-features) VERSION v1.1 SIBLINGS NIL PARASITES
    (swap-bytes/test)) */
