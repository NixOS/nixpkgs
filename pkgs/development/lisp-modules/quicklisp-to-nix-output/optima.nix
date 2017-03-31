args @ { fetchurl, ... }:
rec {
  baseName = ''optima'';
  version = ''20150709-git'';

  description = ''Optimized Pattern Matching Library'';

  deps = [ args."alexandria" args."closer-mop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/optima/2015-07-09/optima-20150709-git.tgz'';
    sha256 = ''0vqyqrnx2d8qwa2jlg9l2wn6vrykraj8a1ysz0gxxxnwpqc29hdc'';
  };

  overrides = x: {
  };
}
