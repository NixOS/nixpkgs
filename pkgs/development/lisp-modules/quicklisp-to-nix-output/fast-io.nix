args @ { fetchurl, ... }:
rec {
  baseName = ''fast-io'';
  version = ''20170124-git'';

  description = ''Alternative I/O mechanism to a stream or vector'';

  deps = [ args."alexandria" args."static-vectors" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-io/2017-01-24/fast-io-20170124-git.tgz'';
    sha256 = ''0w57iddbpdcchnv3zg7agd3ydm36aw2mni4iasi8wd628gq9a6i2'';
  };

  overrides = x: {
  };
}
