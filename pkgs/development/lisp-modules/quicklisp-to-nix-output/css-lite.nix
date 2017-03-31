args @ { fetchurl, ... }:
rec {
  baseName = ''css-lite'';
  version = ''20120407-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/css-lite/2012-04-07/css-lite-20120407-git.tgz'';
    sha256 = ''1gf1qqaxhly6ixh9ykqhg9b52s8p5wlwi46vp2k29qy7gmx4f1qg'';
  };

  overrides = x: {
  };
}
