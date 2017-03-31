args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-types'';
  version = ''20120407-git'';

  description = ''Trivial type definitions'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-types/2012-04-07/trivial-types-20120407-git.tgz'';
    sha256 = ''0y3lfbbvi2qp2cwswzmk1awzqrsrrcfkcm1qn744bgm1fiqhxbxx'';
  };

  overrides = x: {
  };
}
