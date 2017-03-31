args @ { fetchurl, ... }:
rec {
  baseName = ''blackbird'';
  version = ''20160531-git'';

  description = ''A promise implementation for Common Lisp.'';

  deps = [ args."vom" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/blackbird/2016-05-31/blackbird-20160531-git.tgz'';
    sha256 = ''0l053fb5fdz1q6dyfgys6nmbairc3aig4wjl5abpf8b1paf7gzq9'';
  };

  overrides = x: {
  };
}
