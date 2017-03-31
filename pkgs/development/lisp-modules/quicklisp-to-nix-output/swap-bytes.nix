args @ { fetchurl, ... }:
rec {
  baseName = ''swap-bytes'';
  version = ''v1.1'';

  description = ''Optimized byte-swapping primitives.'';

  deps = [ args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/swap-bytes/2016-09-29/swap-bytes-v1.1.tgz'';
    sha256 = ''0snwbfplqhg1y4y4m7lgvksg1hs0sygfikz3rlbkfl4gwg8pq8ky'';
  };

  overrides = x: {
  };
}
